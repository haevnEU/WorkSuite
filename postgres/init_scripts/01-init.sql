CREATE SCHEMA IF NOT EXISTS public;
GRANT ALL ON SCHEMA public TO worksuite_user;
CREATE EXTENSION IF NOT EXISTS "pgcrypto";

CREATE TABLE public.file_meta
(
    id         UUID         NOT NULL PRIMARY KEY,
    checksum   VARCHAR(255) NOT NULL,
    created_at TIMESTAMP(6) NOT NULL,
    deleted    BOOLEAN      NOT NULL,
    file_size  BIGINT       NOT NULL,
    file_type  VARCHAR(255) NOT NULL,
    filename   VARCHAR(255) NOT NULL
);

ALTER TABLE public.file_meta OWNER TO worksuite_user;

CREATE TABLE public.licenses
(
    user_id     UUID                        NOT NULL PRIMARY KEY,
    created_at  TIMESTAMP(6) WITH TIME ZONE NOT NULL,
    expires_at  TIMESTAMP(6) WITH TIME ZONE NOT NULL,
    license_key VARCHAR(255)                NOT NULL,
    plan        VARCHAR(50)                 NOT NULL,
    updated_at  TIMESTAMP(6) WITH TIME ZONE
);

ALTER TABLE public.licenses OWNER TO worksuite_user;

CREATE TABLE public.reviews
(
    id            UUID                        NOT NULL PRIMARY KEY,
    content       TEXT,
    created_at    TIMESTAMP(6) WITH TIME ZONE NOT NULL,
    description   TEXT,
    is_archived   BOOLEAN                     NOT NULL,
    ticket_number VARCHAR(50)                 NOT NULL,
    title         VARCHAR(255)                NOT NULL,
    type          VARCHAR(20)                 NOT NULL
        CONSTRAINT chk_reviews_type
            CHECK ((type)::TEXT = ANY ((ARRAY ['DEMO'::CHARACTER VARYING, 'PRESENTATION'::CHARACTER VARYING])::TEXT[]))
    );

ALTER TABLE public.reviews OWNER TO worksuite_user;

CREATE TABLE public.stats
(
    id                 UUID                        NOT NULL PRIMARY KEY,
    created_at         TIMESTAMP(6) WITH TIME ZONE NOT NULL,
    day                TIMESTAMP(6) WITH TIME ZONE,
    hours_spent        INTEGER,
    moved_to_qa        INTEGER,
    moved_to_review    INTEGER,
    return_from_qa     INTEGER,
    return_from_review INTEGER
);

ALTER TABLE public.stats OWNER TO worksuite_user;

CREATE TABLE public.time_entries
(
    id          UUID                        NOT NULL PRIMARY KEY,
    activity_id BIGINT,
    created_at  TIMESTAMP(6) WITH TIME ZONE NOT NULL,
    date        TIMESTAMP(6) WITH TIME ZONE,
    description VARCHAR(255),
    hours       INTEGER,
    minutes     INTEGER,
    ticket_id   BIGINT
);

ALTER TABLE public.time_entries OWNER TO worksuite_user;

CREATE TABLE public.users
(
    id                 UUID                        NOT NULL PRIMARY KEY,
    avatar_url         VARCHAR(255),
    created_at         TIMESTAMP(6) WITH TIME ZONE NOT NULL,
    first_name         VARCHAR(255),
    last_name          VARCHAR(255),
    license_expiration TIMESTAMP(6) WITH TIME ZONE,
    redmine_key        VARCHAR(255),
    role               VARCHAR(255),
    vcs_key            VARCHAR(255),
    username           TEXT,
    password_hash      TEXT
);

ALTER TABLE public.users OWNER TO worksuite_user;

CREATE TABLE public.weekly_meetings
(
    id         UUID                        NOT NULL PRIMARY KEY,
    created_at TIMESTAMP(6) WITH TIME ZONE NOT NULL,
    summary    TEXT,
    title      VARCHAR(255)
);

ALTER TABLE public.weekly_meetings OWNER TO worksuite_user;

CREATE TABLE public.day_summaries
(
    id                UUID                        NOT NULL PRIMARY KEY,
    created_at        TIMESTAMP(6) WITH TIME ZONE NOT NULL,
    date              TIMESTAMP(6) WITH TIME ZONE,
    summary           TEXT,
    weekly_meeting_id UUID                        NOT NULL
        CONSTRAINT fk_day_summaries_weekly_meetings
            REFERENCES public.weekly_meetings (id) ON DELETE CASCADE
);

ALTER TABLE public.day_summaries OWNER TO worksuite_user;

CREATE TABLE public.day_summary_tasks
(
    day_summary_id UUID NOT NULL
        CONSTRAINT fk_day_summary_tasks_day_summaries
            REFERENCES public.day_summaries (id) ON DELETE CASCADE,
    task           VARCHAR(255)
);

ALTER TABLE public.day_summary_tasks OWNER TO worksuite_user;

CREATE TABLE public.route_usage_metrics
(
    id                UUID                        NOT NULL PRIMARY KEY DEFAULT gen_random_uuid(),
    controller_class  VARCHAR(255)                NOT NULL,
    controller_method VARCHAR(255)                NOT NULL,
    http_method       VARCHAR(10)                 NOT NULL,
    pattern           VARCHAR(255)                NOT NULL,
    invocation_count  BIGINT                      NOT NULL DEFAULT 0,
    first_seen_at     TIMESTAMP(6) WITH TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP,
    last_invoked_at   TIMESTAMP(6) WITH TIME ZONE,
    CONSTRAINT uq_route_usage_method_pattern UNIQUE (http_method, pattern)
);

ALTER TABLE public.route_usage_metrics OWNER TO worksuite_user;