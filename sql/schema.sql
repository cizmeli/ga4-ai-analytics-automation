-- Demo schema for public historical GA4 sample aggregates.
-- Review role grants and Supabase RLS behavior with the actual connection role.
CREATE TABLE IF NOT EXISTS public.weekly_kpis (
    week_start DATE PRIMARY KEY,
    week_end DATE NOT NULL,
    total_events BIGINT NOT NULL CHECK (total_events >= 0),
    total_users BIGINT NOT NULL CHECK (total_users >= 0),
    purchases BIGINT NOT NULL CHECK (purchases >= 0),
    purchase_users BIGINT NOT NULL CHECK (purchase_users >= 0 AND purchase_users <= total_users),
    revenue_usd NUMERIC(18,2) NOT NULL DEFAULT 0 CHECK (revenue_usd >= 0),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    CHECK (week_end >= week_start)
);
ALTER TABLE public.weekly_kpis ENABLE ROW LEVEL SECURITY;

CREATE TABLE IF NOT EXISTS public.weekly_insights (
    week_start DATE PRIMARY KEY,
    week_end DATE NOT NULL,
    report_markdown TEXT NOT NULL,
    metrics_snapshot JSONB,
    model_name TEXT,
    generated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    CHECK (week_end >= week_start)
);
ALTER TABLE public.weekly_insights ENABLE ROW LEVEL SECURITY;

CREATE TABLE IF NOT EXISTS public.weekly_presentations (
    week_start DATE PRIMARY KEY,
    presentation_id TEXT NOT NULL,
    source_report_generated_at TIMESTAMPTZ NOT NULL,
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);
ALTER TABLE public.weekly_presentations ENABLE ROW LEVEL SECURITY;

-- Do not add broad anon/authenticated policies for this demo by default.
-- Grant only SELECT to dedicated dashboard / assistant roles, and narrowly scoped
-- write privileges to the ETL and report-generation roles after checking RLS.
