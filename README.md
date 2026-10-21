# GAMING ZONE — PS4 physical-disc storefront

Responsive Arabic storefront starter with product categories/search/sorting, cart, checkout request form, transfer-payment instructions, and an admin dashboard for managing games and order statuses.

## Run locally
Open `index.html` in a browser. In demo mode, changes and orders are saved only in that browser's local storage. This is useful for previewing the UI, but it is NOT shared between visitors.

## Enable shared online data with Supabase
1. Create a Supabase project.
2. Open SQL Editor and run `supabase.sql`.
3. In `app.js`, replace `YOUR_SUPABASE_URL` and `YOUR_SUPABASE_ANON_KEY` in `CONFIG` with your project's Project URL and anon/public key. Never put a service-role key in browser code.
4. In Supabase Authentication, create an admin user with email/password.
5. Give that user the `admin` role in trusted app metadata using the Supabase dashboard/admin API (do not let the user set their own app metadata). The app checks `app_metadata.role === 'admin'`.
6. Deploy the folder to GitHub and connect the repository to Vercel.
7. Add games in the admin dashboard. Public visitors can submit pending orders; only admin users can read orders and edit products/statuses.

## Before taking real orders
- Replace the default transfer instructions in `CONFIG.paymentInstructions` with your actual safe payment instructions.
- Confirm your stock and prices, condition of each disc, delivery areas/costs, and return policy.
- Current order submission does not automatically reserve/decrement inventory. Add server-side stock validation before relying on it for a busy store.
- Demo mode is browser-local. Shared data only works after Supabase is configured and SQL policies are applied.
- The demo products use third-party image URLs for visual preview. Confirm you have permission to use product imagery in a commercial store and replace broken images as needed.
