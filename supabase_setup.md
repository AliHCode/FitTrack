# Supabase Authentication Setup Guide

## 1. Fix "Email Not Confirmed" Login Issue

**Option A: Disable Email Confirmation (Recommended for Development)**
1.  Go to **Authentication** > **Providers** > **Email**.
2.  Turn **OFF** "Confirm email".
3.  Click **Save**.

**Option B: Keep Email Confirmation (Requires Deep Linking)**
If you keep this on, you **MUST** complete Section 2 below so links open your app.

---

## 2. Configure Deep Linking (Fix "Localhost" Links)

To allow email links (like "Confirm Account" or "Reset Password") to open your app directly:

1.  Go to **Authentication** > **URL Configuration**.
2.  **Site URL**: Set this to:
    `io.fittrack.app://login-callback`
3.  **Redirect URLs**: Add this URL here as well:
    `io.fittrack.app://login-callback`
4.  Click **Save**.

**What this does**:
Supabase will now generate email links starting with `io.fittrack.app://`. Your Android app is configured to "catch" these links and handle the login automatically.

---

## 3. Configure "Forgot Password" Email

1.  Go to **Authentication** > **Email Templates**.
2.  Select **Reset Password**.
3.  Ensure the template body contains the `{{ .ConfirmationURL }}` variable.
    *   *This will automatically use the `io.fittrack.app://` scheme you set above.*
