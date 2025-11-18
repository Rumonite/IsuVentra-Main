# UI Improvement Plan: Natural Dark-Greenish Color Scheme

## Overview
Apply a consistent natural dark-greenish color scheme across the Vue.js frontend to improve overall UI aesthetics. The theme will use dark greens for backgrounds, lighter greens for accents, and white/light text for readability.

## Color Palette
- **Primary Background**: #1a2e1f (deep forest green)
- **Secondary Background**: #2e4d2e (medium dark green)
- **Accent/Primary Color**: #4caf50 (material green)
- **Light Accent**: #81c784 (light green)
- **Text Color**: #e8f5e8 (light green-white)
- **Error Color**: #ff8a80 (soft red for errors)
- **Success Color**: #81c784 (light green for success)

## Tasks
- [ ] Update `frontend/src/App.vue`: Apply dark-green theme to global styles, navigation bar, and buttons
- [ ] Update `frontend/src/views/LoginPage.vue`: Style auth form with dark-green backgrounds, inputs, and buttons
- [ ] Update `frontend/src/views/RegisterPage.vue`: Style registration form consistently with login page
- [ ] Update `frontend/src/views/UserDashboard.vue`: Add dark-green styling to dashboard layout and elements
- [ ] Update `frontend/src/views/admin/AdminDashboard.vue`: Apply theme to admin sidebar, content area, cards, tables, and charts
- [ ] Update `frontend/src/views/JoinPage.vue`: Style QR scanner page with dark-green theme
- [ ] Update `frontend/src/components/HelloWorld.vue`: Apply theme to component if used
- [ ] Update `frontend/src/views/HomeView.vue`: Style home page if applicable
- [ ] Update `frontend/src/views/AboutView.vue`: Style about page if applicable
- [ ] Test UI consistency across all pages

## Implementation Notes
- Use CSS custom properties (variables) for consistent color application
- Ensure sufficient contrast for accessibility (light text on dark backgrounds)
- Maintain responsive design and existing functionality
- Update hover states and active states to fit the theme
- Apply theme to buttons, links, inputs, tables, and other UI elements
