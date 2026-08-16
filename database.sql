create table public.file_meta
(
    id         uuid         not null
        primary key,
    checksum   varchar(255) not null,
    created_at timestamp(6) not null,
    deleted    boolean      not null,
    file_size  bigint       not null,
    file_type  varchar(255) not null,
    filename   varchar(255) not null
);

alter table public.file_meta
    owner to worksuite_user;

create table public.licenses
(
    user_id     uuid                        not null
        primary key,
    created_at  timestamp(6) with time zone not null,
    expires_at  timestamp(6) with time zone not null,
    license_key varchar(255)                not null,
    plan        varchar(50)                 not null,
    updated_at  timestamp(6) with time zone
);

alter table public.licenses
    owner to worksuite_user;

create table public.reviews
(
    id            uuid                        not null
        primary key,
    content       text,
    created_at    timestamp(6) with time zone not null,
    description   text,
    is_archived   boolean                     not null,
    ticket_number varchar(50)                 not null,
    title         varchar(255)                not null,
    type          varchar(20)                 not null
        constraint reviews_type_check
            check ((type)::text = ANY ((ARRAY ['DEMO'::character varying, 'PRESENTATION'::character varying])::text[]))
);

alter table public.reviews
    owner to worksuite_user;

create table public.stats
(
    id                 uuid                        not null
        primary key,
    created_at         timestamp(6) with time zone not null,
    day                timestamp(6) with time zone,
    hours_spent        integer,
    moved_to_qa        integer,
    moved_to_review    integer,
    return_from_qa     integer,
    return_from_review integer
);

alter table public.stats
    owner to worksuite_user;

create table public.time_entries
(
    id          uuid                        not null
        primary key,
    activity_id bigint,
    created_at  timestamp(6) with time zone not null,
    date        timestamp(6) with time zone,
    description varchar(255),
    hours       integer,
    minutes     integer,
    ticket_id   bigint
);

alter table public.time_entries
    owner to worksuite_user;

create table public.users
(
    id                 uuid                        not null
        primary key,
    avatar_url         varchar(255),
    created_at         timestamp(6) with time zone not null,
    first_name         varchar(255),
    last_name          varchar(255),
    license_expiration timestamp(6) with time zone,
    redmine_key        varchar(255),
    role               varchar(255),
    vcs_key            varchar(255),
    username           text,
    password_hash      text
);

alter table public.users
    owner to worksuite_user;

create table public.weekly_meetings
(
    id         uuid                        not null
        primary key,
    created_at timestamp(6) with time zone not null,
    summary    text,
    title      varchar(255)
);

alter table public.weekly_meetings
    owner to worksuite_user;

create table public.day_summaries
(
    id                uuid                        not null
        primary key,
    created_at        timestamp(6) with time zone not null,
    date              timestamp(6) with time zone,
    summary           text,
    weekly_meeting_id uuid                        not null
        constraint fkomyvd8s46y18p6hjs4jrpds21
            references public.weekly_meetings
);

alter table public.day_summaries
    owner to worksuite_user;

create table public.day_summary_tasks
(
    day_summary_id uuid not null
        constraint fk98pqcg87fd806ou1mdeccyjep
            references public.day_summaries,
    task           varchar(255)
);

alter table public.day_summary_tasks
    owner to worksuite_user;

