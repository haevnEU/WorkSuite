-- ============================================================================
-- 1. Dead Code Analysis: Routes that have NEVER been called (invocation_count = 0)
-- ============================================================================
-- Use this query to identify deprecated endpoints or forgotten code paths.
SELECT
    controller_class,
    controller_method,
    http_method,
    pattern,
    first_seen_at
FROM route_usage_metrics
WHERE invocation_count = 0
ORDER BY controller_class ASC, pattern ASC;

-- ============================================================================
-- 2. Access Frequency Analysis: Most frequently used endpoints
-- ============================================================================
-- Use this query to identify high-traffic routes for optimization or caching.
SELECT
    http_method,
    pattern,
    controller_class,
    controller_method,
    invocation_count,
    last_invoked_at
FROM route_usage_metrics
ORDER BY invocation_count DESC;