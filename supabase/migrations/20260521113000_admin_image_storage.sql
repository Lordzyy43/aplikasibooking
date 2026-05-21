insert into storage.buckets (id, name, public, file_size_limit, allowed_mime_types)
values
  (
    'venue-images',
    'venue-images',
    true,
    5242880,
    array['image/jpeg', 'image/png', 'image/webp', 'image/gif']
  ),
  (
    'court-images',
    'court-images',
    true,
    5242880,
    array['image/jpeg', 'image/png', 'image/webp', 'image/gif']
  )
on conflict (id) do update
set
  public = excluded.public,
  file_size_limit = excluded.file_size_limit,
  allowed_mime_types = excluded.allowed_mime_types;

create policy "aerobook_images_public_select"
on storage.objects for select
to anon, authenticated
using (bucket_id in ('venue-images', 'court-images'));

create policy "aerobook_images_admin_insert"
on storage.objects for insert
to authenticated
with check (
  bucket_id in ('venue-images', 'court-images')
  and public.is_admin()
);

create policy "aerobook_images_admin_update"
on storage.objects for update
to authenticated
using (
  bucket_id in ('venue-images', 'court-images')
  and public.is_admin()
)
with check (
  bucket_id in ('venue-images', 'court-images')
  and public.is_admin()
);

create policy "aerobook_images_admin_delete"
on storage.objects for delete
to authenticated
using (
  bucket_id in ('venue-images', 'court-images')
  and public.is_admin()
);
