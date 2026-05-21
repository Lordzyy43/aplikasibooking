create or replace function public.handle_new_user()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
begin
  insert into public.profiles (id, full_name, phone, avatar_url)
  values (
    new.id,
    coalesce(
      nullif(new.raw_user_meta_data->>'full_name', ''),
      nullif(new.raw_user_meta_data->>'name', ''),
      nullif(split_part(new.email, '@', 1), ''),
      'User Aerobook'
    ),
    nullif(new.raw_user_meta_data->>'phone', ''),
    nullif(new.raw_user_meta_data->>'avatar_url', '')
  )
  on conflict (id) do nothing;

  return new;
exception
  when others then
    raise warning 'handle_new_user failed for auth user %: %', new.id, sqlerrm;
    return new;
end;
$$;

create or replace function public.ensure_customer_profile()
returns public.profiles
language plpgsql
security definer
set search_path = public, auth
as $$
declare
  v_profile public.profiles;
  v_email text;
  v_meta jsonb;
begin
  if auth.uid() is null then
    raise exception 'Authentication required';
  end if;

  select email, raw_user_meta_data
  into v_email, v_meta
  from auth.users
  where id = auth.uid();

  insert into public.profiles (id, full_name, phone, avatar_url)
  values (
    auth.uid(),
    coalesce(
      nullif(v_meta->>'full_name', ''),
      nullif(v_meta->>'name', ''),
      nullif(split_part(v_email, '@', 1), ''),
      'User Aerobook'
    ),
    nullif(v_meta->>'phone', ''),
    nullif(v_meta->>'avatar_url', '')
  )
  on conflict (id) do update
  set
    full_name = coalesce(nullif(public.profiles.full_name, ''), excluded.full_name),
    phone = coalesce(public.profiles.phone, excluded.phone),
    avatar_url = coalesce(public.profiles.avatar_url, excluded.avatar_url)
  returning * into v_profile;

  return v_profile;
end;
$$;

grant execute on function public.ensure_customer_profile() to authenticated;
