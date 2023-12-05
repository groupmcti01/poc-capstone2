output "url" {
  description = "Bucket URL (for single use)."
  value       = google_storage_bucket.capstone2_poc.url
}

output "default_account" {
  value = data.google_compute_default_service_account.default.email
}
