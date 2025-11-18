# TODO: Add Statistics to Admin Dashboard

## Backend Changes
- [x] Add `getParticipationStats()` method in `ParticipationController.php` to fetch daily participation counts grouped by date of `time_in`.
- [x] Add protected API route `/participation/stats` in `routes/api.php` (admin-only via AdminCheck middleware).

## Frontend Changes
- [x] In `AdminDashboard.vue`, add data fetching for participation stats from new API endpoint.
- [x] Compute 7-day simple moving average on daily participation counts.
- [x] Compute exponential smoothing (alpha=0.3) on daily participation counts.
- [x] Add two new chart containers (line charts using Chart.js) for moving average and exponential smoothing below the existing bar chart.

## Testing and Verification
- [x] Fixed runtime errors in chart rendering functions by adding array checks.
- [x] Created ParticipationFactory and ParticipationSeeder to generate example participation data.
- [x] Updated DatabaseSeeder to include ParticipationSeeder.
- [x] Ran migrate:fresh --seed to populate database with sample data.
- [ ] Test the new API endpoint `/api/participation/stats` to ensure it returns correct daily stats data.
- [ ] Run the frontend application and verify that the new charts render correctly on the admin dashboard.
- [ ] Adjust smoothing parameters or add more statistics if needed based on testing.
