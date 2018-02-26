--
-- PostgreSQL database dump
--

-- Dumped from database version 9.5.9
-- Dumped by pg_dump version 9.5.9

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


--
-- Name: pg_trgm; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pg_trgm WITH SCHEMA public;


--
-- Name: EXTENSION pg_trgm; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION pg_trgm IS 'text similarity measurement and index searching based on trigrams';


--
-- Name: tablefunc; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS tablefunc WITH SCHEMA public;


--
-- Name: EXTENSION tablefunc; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION tablefunc IS 'functions that manipulate whole tables, including crosstab';


SET search_path = public, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: colors; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE colors (
    id integer NOT NULL,
    name character varying NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: colors_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE colors_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: colors_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE colors_id_seq OWNED BY colors.id;


--
-- Name: contests; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE contests (
    id integer NOT NULL,
    name character varying NOT NULL,
    start_time timestamp without time zone NOT NULL,
    end_time timestamp without time zone NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    problem_pdf_file_name character varying,
    problem_pdf_content_type character varying,
    problem_pdf_file_size integer,
    problem_pdf_updated_at timestamp without time zone,
    rule text DEFAULT ''::text,
    result_time timestamp without time zone NOT NULL,
    feedback_time timestamp without time zone NOT NULL,
    gold_cutoff integer DEFAULT 0 NOT NULL,
    silver_cutoff integer DEFAULT 0 NOT NULL,
    bronze_cutoff integer DEFAULT 0 NOT NULL,
    result_released boolean DEFAULT false NOT NULL,
    problem_tex_file_name character varying,
    problem_tex_content_type character varying,
    problem_tex_file_size integer,
    problem_tex_updated_at timestamp without time zone,
    marking_scheme_file_name character varying,
    marking_scheme_content_type character varying,
    marking_scheme_file_size integer,
    marking_scheme_updated_at timestamp without time zone,
    book_promo character varying,
    timer interval hour to second
);


--
-- Name: contests_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE contests_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: contests_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE contests_id_seq OWNED BY contests.id;


--
-- Name: delayed_jobs; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE delayed_jobs (
    id integer NOT NULL,
    priority integer DEFAULT 0 NOT NULL,
    attempts integer DEFAULT 0 NOT NULL,
    handler text NOT NULL,
    last_error text,
    run_at timestamp without time zone,
    locked_at timestamp without time zone,
    failed_at timestamp without time zone,
    locked_by character varying,
    queue character varying,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: delayed_jobs_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE delayed_jobs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: delayed_jobs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE delayed_jobs_id_seq OWNED BY delayed_jobs.id;


--
-- Name: feedback_answers; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE feedback_answers (
    id integer NOT NULL,
    feedback_question_id integer NOT NULL,
    answer text NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    user_contest_id integer NOT NULL
);


--
-- Name: feedback_answers_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE feedback_answers_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: feedback_answers_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE feedback_answers_id_seq OWNED BY feedback_answers.id;


--
-- Name: feedback_questions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE feedback_questions (
    id integer NOT NULL,
    question text,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    contest_id integer NOT NULL
);


--
-- Name: feedback_questions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE feedback_questions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: feedback_questions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE feedback_questions_id_seq OWNED BY feedback_questions.id;


--
-- Name: long_problems; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE long_problems (
    id integer NOT NULL,
    contest_id integer NOT NULL,
    problem_no integer NOT NULL,
    statement text NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    report_file_name character varying,
    report_content_type character varying,
    report_file_size integer,
    report_updated_at timestamp without time zone,
    start_time timestamp without time zone,
    end_time timestamp without time zone
);


--
-- Name: long_problems_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE long_problems_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: long_problems_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE long_problems_id_seq OWNED BY long_problems.id;


--
-- Name: long_submissions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE long_submissions (
    id integer NOT NULL,
    long_problem_id integer NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    score integer,
    feedback character varying DEFAULT ''::character varying NOT NULL,
    user_contest_id integer NOT NULL
);


--
-- Name: long_submissions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE long_submissions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: long_submissions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE long_submissions_id_seq OWNED BY long_submissions.id;


--
-- Name: market_item_pictures; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE market_item_pictures (
    id integer NOT NULL,
    market_item_id integer NOT NULL,
    picture_file_name character varying,
    picture_content_type character varying,
    picture_file_size integer,
    picture_updated_at timestamp without time zone,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: market_item_pictures_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE market_item_pictures_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: market_item_pictures_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE market_item_pictures_id_seq OWNED BY market_item_pictures.id;


--
-- Name: market_items; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE market_items (
    id integer NOT NULL,
    name character varying NOT NULL,
    description text NOT NULL,
    price integer NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    quantity integer
);


--
-- Name: market_items_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE market_items_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: market_items_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE market_items_id_seq OWNED BY market_items.id;


--
-- Name: market_orders; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE market_orders (
    id integer NOT NULL,
    point_transaction_id integer,
    market_item_id integer,
    quantity integer,
    email character varying,
    phone character varying,
    address character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: market_orders_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE market_orders_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: market_orders_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE market_orders_id_seq OWNED BY market_orders.id;


--
-- Name: migration_validators; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE migration_validators (
    id integer NOT NULL,
    table_name character varying NOT NULL,
    column_name character varying NOT NULL,
    validation_type character varying NOT NULL,
    options character varying
);


--
-- Name: migration_validators_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE migration_validators_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: migration_validators_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE migration_validators_id_seq OWNED BY migration_validators.id;


--
-- Name: notifications; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE notifications (
    id integer NOT NULL,
    event character varying NOT NULL,
    time_text character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    description character varying NOT NULL,
    seconds integer
);


--
-- Name: notifications_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE notifications_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: notifications_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE notifications_id_seq OWNED BY notifications.id;


--
-- Name: point_transactions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE point_transactions (
    id integer NOT NULL,
    point integer NOT NULL,
    description character varying NOT NULL,
    user_id integer NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: point_transactions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE point_transactions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: point_transactions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE point_transactions_id_seq OWNED BY point_transactions.id;


--
-- Name: provinces; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE provinces (
    id integer NOT NULL,
    name character varying NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    timezone character varying NOT NULL
);


--
-- Name: provinces_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE provinces_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: provinces_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE provinces_id_seq OWNED BY provinces.id;


--
-- Name: referrers; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE referrers (
    id integer NOT NULL,
    name character varying NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: referrers_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE referrers_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: referrers_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE referrers_id_seq OWNED BY referrers.id;


--
-- Name: roles; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE roles (
    id integer NOT NULL,
    name character varying,
    resource_id integer,
    resource_type character varying,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: roles_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE roles_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: roles_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE roles_id_seq OWNED BY roles.id;


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE schema_migrations (
    version character varying NOT NULL
);


--
-- Name: short_problems; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE short_problems (
    id integer NOT NULL,
    contest_id integer NOT NULL,
    problem_no integer NOT NULL,
    statement character varying DEFAULT ''::character varying NOT NULL,
    answer character varying NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    start_time timestamp without time zone,
    end_time timestamp without time zone
);


--
-- Name: short_problems_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE short_problems_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: short_problems_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE short_problems_id_seq OWNED BY short_problems.id;


--
-- Name: short_submissions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE short_submissions (
    id integer NOT NULL,
    short_problem_id integer NOT NULL,
    answer character varying NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    user_contest_id integer NOT NULL
);


--
-- Name: short_submissions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE short_submissions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: short_submissions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE short_submissions_id_seq OWNED BY short_submissions.id;


--
-- Name: statuses; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE statuses (
    id integer NOT NULL,
    name character varying NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    CONSTRAINT chk_mv_statuses_name CHECK (((name IS NOT NULL) AND (length(btrim((name)::text)) > 0)))
);


--
-- Name: statuses_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE statuses_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: statuses_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE statuses_id_seq OWNED BY statuses.id;


--
-- Name: submission_pages; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE submission_pages (
    id integer NOT NULL,
    page_number integer NOT NULL,
    long_submission_id integer NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    submission_file_name character varying,
    submission_content_type character varying,
    submission_file_size integer,
    submission_updated_at timestamp without time zone
);


--
-- Name: submission_pages_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE submission_pages_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: submission_pages_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE submission_pages_id_seq OWNED BY submission_pages.id;


--
-- Name: temporary_markings; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE temporary_markings (
    id integer NOT NULL,
    user_id integer NOT NULL,
    long_submission_id integer NOT NULL,
    mark integer,
    tags character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: temporary_markings_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE temporary_markings_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: temporary_markings_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE temporary_markings_id_seq OWNED BY temporary_markings.id;


--
-- Name: user_contests; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE user_contests (
    id integer NOT NULL,
    user_id integer NOT NULL,
    contest_id integer NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    certificate_sent boolean DEFAULT false NOT NULL,
    end_time timestamp without time zone
);


--
-- Name: user_contests_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE user_contests_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: user_contests_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE user_contests_id_seq OWNED BY user_contests.id;


--
-- Name: user_notifications; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE user_notifications (
    id integer NOT NULL,
    user_id integer NOT NULL,
    notification_id integer NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: user_notifications_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE user_notifications_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: user_notifications_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE user_notifications_id_seq OWNED BY user_notifications.id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE users (
    id integer NOT NULL,
    username character varying NOT NULL,
    email character varying NOT NULL,
    hashed_password character varying NOT NULL,
    fullname character varying NOT NULL,
    school character varying NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    salt character varying NOT NULL,
    auth_token character varying NOT NULL,
    province_id integer,
    status_id integer,
    color_id integer DEFAULT 1 NOT NULL,
    timezone character varying DEFAULT 'WIB'::character varying NOT NULL,
    verification character varying,
    enabled boolean DEFAULT false NOT NULL,
    tries integer DEFAULT 0 NOT NULL,
    referrer_id integer,
    CONSTRAINT users_username_lowercase_check CHECK (((username)::text = lower((username)::text)))
);


--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE users_id_seq OWNED BY users.id;


--
-- Name: users_roles; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE users_roles (
    user_id integer,
    role_id integer
);


--
-- Name: version_associations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE version_associations (
    id integer NOT NULL,
    version_id integer,
    foreign_key_name character varying NOT NULL,
    foreign_key_id integer
);


--
-- Name: version_associations_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE version_associations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: version_associations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE version_associations_id_seq OWNED BY version_associations.id;


--
-- Name: versions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE versions (
    id integer NOT NULL,
    item_type character varying NOT NULL,
    item_id integer NOT NULL,
    event character varying NOT NULL,
    whodunnit character varying,
    object text,
    created_at timestamp without time zone,
    object_changes text,
    transaction_id integer
);


--
-- Name: versions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE versions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: versions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE versions_id_seq OWNED BY versions.id;


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY colors ALTER COLUMN id SET DEFAULT nextval('colors_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY contests ALTER COLUMN id SET DEFAULT nextval('contests_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY delayed_jobs ALTER COLUMN id SET DEFAULT nextval('delayed_jobs_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY feedback_answers ALTER COLUMN id SET DEFAULT nextval('feedback_answers_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY feedback_questions ALTER COLUMN id SET DEFAULT nextval('feedback_questions_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY long_problems ALTER COLUMN id SET DEFAULT nextval('long_problems_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY long_submissions ALTER COLUMN id SET DEFAULT nextval('long_submissions_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY market_item_pictures ALTER COLUMN id SET DEFAULT nextval('market_item_pictures_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY market_items ALTER COLUMN id SET DEFAULT nextval('market_items_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY market_orders ALTER COLUMN id SET DEFAULT nextval('market_orders_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY migration_validators ALTER COLUMN id SET DEFAULT nextval('migration_validators_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY notifications ALTER COLUMN id SET DEFAULT nextval('notifications_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY point_transactions ALTER COLUMN id SET DEFAULT nextval('point_transactions_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY provinces ALTER COLUMN id SET DEFAULT nextval('provinces_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY referrers ALTER COLUMN id SET DEFAULT nextval('referrers_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY roles ALTER COLUMN id SET DEFAULT nextval('roles_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY short_problems ALTER COLUMN id SET DEFAULT nextval('short_problems_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY short_submissions ALTER COLUMN id SET DEFAULT nextval('short_submissions_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY statuses ALTER COLUMN id SET DEFAULT nextval('statuses_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY submission_pages ALTER COLUMN id SET DEFAULT nextval('submission_pages_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY temporary_markings ALTER COLUMN id SET DEFAULT nextval('temporary_markings_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY user_contests ALTER COLUMN id SET DEFAULT nextval('user_contests_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY user_notifications ALTER COLUMN id SET DEFAULT nextval('user_notifications_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY users ALTER COLUMN id SET DEFAULT nextval('users_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY version_associations ALTER COLUMN id SET DEFAULT nextval('version_associations_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY versions ALTER COLUMN id SET DEFAULT nextval('versions_id_seq'::regclass);


--
-- Name: colors_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY colors
    ADD CONSTRAINT colors_pkey PRIMARY KEY (id);


--
-- Name: contests_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY contests
    ADD CONSTRAINT contests_pkey PRIMARY KEY (id);


--
-- Name: delayed_jobs_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY delayed_jobs
    ADD CONSTRAINT delayed_jobs_pkey PRIMARY KEY (id);


--
-- Name: feedback_answers_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY feedback_answers
    ADD CONSTRAINT feedback_answers_pkey PRIMARY KEY (id);


--
-- Name: feedback_questions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY feedback_questions
    ADD CONSTRAINT feedback_questions_pkey PRIMARY KEY (id);


--
-- Name: long_problems_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY long_problems
    ADD CONSTRAINT long_problems_pkey PRIMARY KEY (id);


--
-- Name: long_submissions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY long_submissions
    ADD CONSTRAINT long_submissions_pkey PRIMARY KEY (id);


--
-- Name: market_item_pictures_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY market_item_pictures
    ADD CONSTRAINT market_item_pictures_pkey PRIMARY KEY (id);


--
-- Name: market_items_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY market_items
    ADD CONSTRAINT market_items_pkey PRIMARY KEY (id);


--
-- Name: market_orders_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY market_orders
    ADD CONSTRAINT market_orders_pkey PRIMARY KEY (id);


--
-- Name: migration_validators_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY migration_validators
    ADD CONSTRAINT migration_validators_pkey PRIMARY KEY (id);


--
-- Name: notifications_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY notifications
    ADD CONSTRAINT notifications_pkey PRIMARY KEY (id);


--
-- Name: point_transactions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY point_transactions
    ADD CONSTRAINT point_transactions_pkey PRIMARY KEY (id);


--
-- Name: provinces_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY provinces
    ADD CONSTRAINT provinces_pkey PRIMARY KEY (id);


--
-- Name: referrers_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY referrers
    ADD CONSTRAINT referrers_pkey PRIMARY KEY (id);


--
-- Name: roles_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY roles
    ADD CONSTRAINT roles_pkey PRIMARY KEY (id);


--
-- Name: short_problems_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY short_problems
    ADD CONSTRAINT short_problems_pkey PRIMARY KEY (id);


--
-- Name: short_submissions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY short_submissions
    ADD CONSTRAINT short_submissions_pkey PRIMARY KEY (id);


--
-- Name: statuses_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY statuses
    ADD CONSTRAINT statuses_pkey PRIMARY KEY (id);


--
-- Name: submission_pages_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY submission_pages
    ADD CONSTRAINT submission_pages_pkey PRIMARY KEY (id);


--
-- Name: temporary_markings_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY temporary_markings
    ADD CONSTRAINT temporary_markings_pkey PRIMARY KEY (id);


--
-- Name: user_contests_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY user_contests
    ADD CONSTRAINT user_contests_pkey PRIMARY KEY (id);


--
-- Name: user_notifications_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY user_notifications
    ADD CONSTRAINT user_notifications_pkey PRIMARY KEY (id);


--
-- Name: users_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: version_associations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY version_associations
    ADD CONSTRAINT version_associations_pkey PRIMARY KEY (id);


--
-- Name: versions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY versions
    ADD CONSTRAINT versions_pkey PRIMARY KEY (id);


--
-- Name: delayed_jobs_priority; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX delayed_jobs_priority ON delayed_jobs USING btree (priority, run_at);


--
-- Name: feedback_question_and_user_contest_unique_pair; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX feedback_question_and_user_contest_unique_pair ON feedback_answers USING btree (feedback_question_id, user_contest_id);


--
-- Name: index_colors_on_name; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_colors_on_name ON colors USING btree (name);


--
-- Name: index_contests_on_end_time; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_contests_on_end_time ON contests USING btree (end_time);


--
-- Name: index_contests_on_feedback_time; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_contests_on_feedback_time ON contests USING btree (feedback_time);


--
-- Name: index_contests_on_result_time; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_contests_on_result_time ON contests USING btree (result_time);


--
-- Name: index_contests_on_start_time; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_contests_on_start_time ON contests USING btree (start_time);


--
-- Name: index_feedback_questions_on_contest_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_feedback_questions_on_contest_id ON feedback_questions USING btree (contest_id);


--
-- Name: index_long_problems_on_contest_id_and_problem_no; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_long_problems_on_contest_id_and_problem_no ON long_problems USING btree (contest_id, problem_no);


--
-- Name: index_long_submissions_on_long_problem_id_and_user_contest_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_long_submissions_on_long_problem_id_and_user_contest_id ON long_submissions USING btree (long_problem_id, user_contest_id);


--
-- Name: index_market_item_pictures_on_market_item_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_market_item_pictures_on_market_item_id ON market_item_pictures USING btree (market_item_id);


--
-- Name: index_market_orders_on_market_item_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_market_orders_on_market_item_id ON market_orders USING btree (market_item_id);


--
-- Name: index_market_orders_on_point_transaction_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_market_orders_on_point_transaction_id ON market_orders USING btree (point_transaction_id);


--
-- Name: index_point_transactions_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_point_transactions_on_user_id ON point_transactions USING btree (user_id);


--
-- Name: index_provinces_on_name; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_provinces_on_name ON provinces USING btree (name);


--
-- Name: index_referrers_on_name; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_referrers_on_name ON referrers USING btree (name);


--
-- Name: index_roles_on_name; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_roles_on_name ON roles USING btree (name);


--
-- Name: index_roles_on_name_and_resource_type_and_resource_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_roles_on_name_and_resource_type_and_resource_id ON roles USING btree (name, resource_type, resource_id);


--
-- Name: index_roles_on_resource_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_roles_on_resource_id ON roles USING btree (resource_id);


--
-- Name: index_short_problems_on_contest_id_and_problem_no; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_short_problems_on_contest_id_and_problem_no ON short_problems USING btree (contest_id, problem_no);


--
-- Name: index_short_submissions_on_short_problem_id_and_user_contest_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_short_submissions_on_short_problem_id_and_user_contest_id ON short_submissions USING btree (short_problem_id, user_contest_id);


--
-- Name: index_statuses_on_name; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_statuses_on_name ON statuses USING btree (name);


--
-- Name: index_submission_pages_on_page_number_and_long_submission_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_submission_pages_on_page_number_and_long_submission_id ON submission_pages USING btree (page_number, long_submission_id);


--
-- Name: index_temporary_markings_on_user_id_and_long_submission_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_temporary_markings_on_user_id_and_long_submission_id ON temporary_markings USING btree (user_id, long_submission_id);


--
-- Name: index_user_contests_on_user_id_and_contest_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_user_contests_on_user_id_and_contest_id ON user_contests USING btree (user_id, contest_id);


--
-- Name: index_user_notifications_on_user_id_and_notification_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_user_notifications_on_user_id_and_notification_id ON user_notifications USING btree (user_id, notification_id);


--
-- Name: index_users_on_auth_token; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_users_on_auth_token ON users USING btree (auth_token);


--
-- Name: index_users_on_color_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_users_on_color_id ON users USING btree (color_id);


--
-- Name: index_users_on_email; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_users_on_email ON users USING btree (email);


--
-- Name: index_users_on_province_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_users_on_province_id ON users USING btree (province_id);


--
-- Name: index_users_on_referrer_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_users_on_referrer_id ON users USING btree (referrer_id);


--
-- Name: index_users_on_status_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_users_on_status_id ON users USING btree (status_id);


--
-- Name: index_users_on_username; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_users_on_username ON users USING btree (username);


--
-- Name: index_users_on_username_gin; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_users_on_username_gin ON users USING gin (username gin_trgm_ops);


--
-- Name: index_users_on_verification; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_users_on_verification ON users USING btree (verification);


--
-- Name: index_users_roles_on_user_id_and_role_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_users_roles_on_user_id_and_role_id ON users_roles USING btree (user_id, role_id);


--
-- Name: index_version_associations_on_foreign_key; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_version_associations_on_foreign_key ON version_associations USING btree (foreign_key_name, foreign_key_id);


--
-- Name: index_version_associations_on_version_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_version_associations_on_version_id ON version_associations USING btree (version_id);


--
-- Name: index_versions_on_item_type_and_item_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_versions_on_item_type_and_item_id ON versions USING btree (item_type, item_id);


--
-- Name: index_versions_on_transaction_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_versions_on_transaction_id ON versions USING btree (transaction_id);


--
-- Name: unique_idx_on_migration_validators; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX unique_idx_on_migration_validators ON migration_validators USING btree (table_name, column_name, validation_type);


--
-- Name: unique_schema_migrations; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX unique_schema_migrations ON schema_migrations USING btree (version);


--
-- Name: fk_rails_0615442e63; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY feedback_answers
    ADD CONSTRAINT fk_rails_0615442e63 FOREIGN KEY (feedback_question_id) REFERENCES feedback_questions(id) ON DELETE CASCADE;


--
-- Name: fk_rails_116a6ecec7; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY long_problems
    ADD CONSTRAINT fk_rails_116a6ecec7 FOREIGN KEY (contest_id) REFERENCES contests(id) ON DELETE CASCADE;


--
-- Name: fk_rails_117485e784; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY short_submissions
    ADD CONSTRAINT fk_rails_117485e784 FOREIGN KEY (user_contest_id) REFERENCES user_contests(id) ON DELETE CASCADE;


--
-- Name: fk_rails_1467c5d84d; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY short_submissions
    ADD CONSTRAINT fk_rails_1467c5d84d FOREIGN KEY (short_problem_id) REFERENCES short_problems(id) ON DELETE CASCADE;


--
-- Name: fk_rails_349a6ecb7e; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY temporary_markings
    ADD CONSTRAINT fk_rails_349a6ecb7e FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE;


--
-- Name: fk_rails_374404a088; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY feedback_answers
    ADD CONSTRAINT fk_rails_374404a088 FOREIGN KEY (user_contest_id) REFERENCES user_contests(id) ON DELETE CASCADE;


--
-- Name: fk_rails_38d13509cf; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY feedback_questions
    ADD CONSTRAINT fk_rails_38d13509cf FOREIGN KEY (contest_id) REFERENCES contests(id) ON DELETE CASCADE;


--
-- Name: fk_rails_418fd0bbd0; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY user_contests
    ADD CONSTRAINT fk_rails_418fd0bbd0 FOREIGN KEY (contest_id) REFERENCES contests(id) ON DELETE CASCADE;


--
-- Name: fk_rails_560da4bd54; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY users
    ADD CONSTRAINT fk_rails_560da4bd54 FOREIGN KEY (province_id) REFERENCES provinces(id) ON DELETE SET NULL;


--
-- Name: fk_rails_60f1de2193; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY short_problems
    ADD CONSTRAINT fk_rails_60f1de2193 FOREIGN KEY (contest_id) REFERENCES contests(id) ON DELETE CASCADE;


--
-- Name: fk_rails_62bec7c828; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY submission_pages
    ADD CONSTRAINT fk_rails_62bec7c828 FOREIGN KEY (long_submission_id) REFERENCES long_submissions(id) ON DELETE CASCADE;


--
-- Name: fk_rails_7d71f7cc8f; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY market_item_pictures
    ADD CONSTRAINT fk_rails_7d71f7cc8f FOREIGN KEY (market_item_id) REFERENCES market_items(id) ON DELETE CASCADE;


--
-- Name: fk_rails_7dcab47693; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY temporary_markings
    ADD CONSTRAINT fk_rails_7dcab47693 FOREIGN KEY (long_submission_id) REFERENCES long_submissions(id) ON DELETE CASCADE;


--
-- Name: fk_rails_87f75b7957; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY users
    ADD CONSTRAINT fk_rails_87f75b7957 FOREIGN KEY (color_id) REFERENCES colors(id) ON DELETE SET NULL;


--
-- Name: fk_rails_ab0e9f9d12; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY long_submissions
    ADD CONSTRAINT fk_rails_ab0e9f9d12 FOREIGN KEY (user_contest_id) REFERENCES user_contests(id) ON DELETE CASCADE;


--
-- Name: fk_rails_cdbff2ee9e; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY user_notifications
    ADD CONSTRAINT fk_rails_cdbff2ee9e FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE;


--
-- Name: fk_rails_ce4a327a04; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY users
    ADD CONSTRAINT fk_rails_ce4a327a04 FOREIGN KEY (status_id) REFERENCES statuses(id) ON DELETE SET NULL;


--
-- Name: fk_rails_d238d8ef07; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY user_notifications
    ADD CONSTRAINT fk_rails_d238d8ef07 FOREIGN KEY (notification_id) REFERENCES notifications(id) ON DELETE CASCADE;


--
-- Name: fk_rails_ee078c9177; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY user_contests
    ADD CONSTRAINT fk_rails_ee078c9177 FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE;


--
-- Name: fk_rails_f4fee8fddd; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY long_submissions
    ADD CONSTRAINT fk_rails_f4fee8fddd FOREIGN KEY (long_problem_id) REFERENCES long_problems(id) ON DELETE CASCADE;


--
-- Name: fk_rails_fc956f9f03; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY point_transactions
    ADD CONSTRAINT fk_rails_fc956f9f03 FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE;


--
-- PostgreSQL database dump complete
--

SET search_path TO "$user", public;

INSERT INTO schema_migrations (version) VALUES ('20160215163631');

INSERT INTO schema_migrations (version) VALUES ('20160216110237');

INSERT INTO schema_migrations (version) VALUES ('20160216114412');

INSERT INTO schema_migrations (version) VALUES ('20160326180041');

INSERT INTO schema_migrations (version) VALUES ('20160404090458');

INSERT INTO schema_migrations (version) VALUES ('20160428202525');

INSERT INTO schema_migrations (version) VALUES ('20160502194650');

INSERT INTO schema_migrations (version) VALUES ('20160502195254');

INSERT INTO schema_migrations (version) VALUES ('20160502201402');

INSERT INTO schema_migrations (version) VALUES ('20160502201418');

INSERT INTO schema_migrations (version) VALUES ('20160502230426');

INSERT INTO schema_migrations (version) VALUES ('20160502231622');

INSERT INTO schema_migrations (version) VALUES ('20160507185159');

INSERT INTO schema_migrations (version) VALUES ('20160507220530');

INSERT INTO schema_migrations (version) VALUES ('20160522071340');

INSERT INTO schema_migrations (version) VALUES ('20160522090953');

INSERT INTO schema_migrations (version) VALUES ('20160522091423');

INSERT INTO schema_migrations (version) VALUES ('20160522100000');

INSERT INTO schema_migrations (version) VALUES ('20160522110000');

INSERT INTO schema_migrations (version) VALUES ('20160522152016');

INSERT INTO schema_migrations (version) VALUES ('20160522173347');

INSERT INTO schema_migrations (version) VALUES ('20160522173630');

INSERT INTO schema_migrations (version) VALUES ('20160522174618');

INSERT INTO schema_migrations (version) VALUES ('20160522180330');

INSERT INTO schema_migrations (version) VALUES ('20160522180331');

INSERT INTO schema_migrations (version) VALUES ('20160522180332');

INSERT INTO schema_migrations (version) VALUES ('20160522180333');

INSERT INTO schema_migrations (version) VALUES ('20160522180424');

INSERT INTO schema_migrations (version) VALUES ('20160529071200');

INSERT INTO schema_migrations (version) VALUES ('20160529151359');

INSERT INTO schema_migrations (version) VALUES ('20160529152106');

INSERT INTO schema_migrations (version) VALUES ('20160612082425');

INSERT INTO schema_migrations (version) VALUES ('20160613165643');

INSERT INTO schema_migrations (version) VALUES ('20160613170017');

INSERT INTO schema_migrations (version) VALUES ('20160614060706');

INSERT INTO schema_migrations (version) VALUES ('20160614060717');

INSERT INTO schema_migrations (version) VALUES ('20160614065545');

INSERT INTO schema_migrations (version) VALUES ('20160614073120');

INSERT INTO schema_migrations (version) VALUES ('20160618143907');

INSERT INTO schema_migrations (version) VALUES ('20160619083225');

INSERT INTO schema_migrations (version) VALUES ('20160619083243');

INSERT INTO schema_migrations (version) VALUES ('20160619113034');

INSERT INTO schema_migrations (version) VALUES ('20160619113128');

INSERT INTO schema_migrations (version) VALUES ('20160702092127');

INSERT INTO schema_migrations (version) VALUES ('20160702095227');

INSERT INTO schema_migrations (version) VALUES ('20160702095353');

INSERT INTO schema_migrations (version) VALUES ('20160702100530');

INSERT INTO schema_migrations (version) VALUES ('20160702100736');

INSERT INTO schema_migrations (version) VALUES ('20160702101103');

INSERT INTO schema_migrations (version) VALUES ('20160702102022');

INSERT INTO schema_migrations (version) VALUES ('20160702102040');

INSERT INTO schema_migrations (version) VALUES ('20160702102335');

INSERT INTO schema_migrations (version) VALUES ('20160703090048');

INSERT INTO schema_migrations (version) VALUES ('20160703160846');

INSERT INTO schema_migrations (version) VALUES ('20160703185043');

INSERT INTO schema_migrations (version) VALUES ('20160705122134');

INSERT INTO schema_migrations (version) VALUES ('20160705122941');

INSERT INTO schema_migrations (version) VALUES ('20160706113410');

INSERT INTO schema_migrations (version) VALUES ('20160706120600');

INSERT INTO schema_migrations (version) VALUES ('20160706120738');

INSERT INTO schema_migrations (version) VALUES ('20160706121308');

INSERT INTO schema_migrations (version) VALUES ('20160707152010');

INSERT INTO schema_migrations (version) VALUES ('20160709150245');

INSERT INTO schema_migrations (version) VALUES ('20160710154832');

INSERT INTO schema_migrations (version) VALUES ('20160710154849');

INSERT INTO schema_migrations (version) VALUES ('20160710173756');

INSERT INTO schema_migrations (version) VALUES ('20160710182003');

INSERT INTO schema_migrations (version) VALUES ('20160712051842');

INSERT INTO schema_migrations (version) VALUES ('20160712154745');

INSERT INTO schema_migrations (version) VALUES ('20160712180553');

INSERT INTO schema_migrations (version) VALUES ('20160713052032');

INSERT INTO schema_migrations (version) VALUES ('20160714041253');

INSERT INTO schema_migrations (version) VALUES ('20160714154105');

INSERT INTO schema_migrations (version) VALUES ('20160714174434');

INSERT INTO schema_migrations (version) VALUES ('20160716000155');

INSERT INTO schema_migrations (version) VALUES ('20160720081651');

INSERT INTO schema_migrations (version) VALUES ('20160720082711');

INSERT INTO schema_migrations (version) VALUES ('20160720155458');

INSERT INTO schema_migrations (version) VALUES ('20160726085657');

INSERT INTO schema_migrations (version) VALUES ('20160730035813');

INSERT INTO schema_migrations (version) VALUES ('20160730161813');

INSERT INTO schema_migrations (version) VALUES ('20160730173851');

INSERT INTO schema_migrations (version) VALUES ('20160804110128');

INSERT INTO schema_migrations (version) VALUES ('20160809150225');

INSERT INTO schema_migrations (version) VALUES ('20160818025113');

INSERT INTO schema_migrations (version) VALUES ('20160831112025');

INSERT INTO schema_migrations (version) VALUES ('20160831124049');

INSERT INTO schema_migrations (version) VALUES ('20160918043247');

INSERT INTO schema_migrations (version) VALUES ('20160918044056');

INSERT INTO schema_migrations (version) VALUES ('20161006012803');

INSERT INTO schema_migrations (version) VALUES ('20161006191146');

INSERT INTO schema_migrations (version) VALUES ('20161006191442');

INSERT INTO schema_migrations (version) VALUES ('20161006192548');

INSERT INTO schema_migrations (version) VALUES ('20161014091434');

INSERT INTO schema_migrations (version) VALUES ('20161102163618');

INSERT INTO schema_migrations (version) VALUES ('20161102163917');

INSERT INTO schema_migrations (version) VALUES ('20161103010922');

INSERT INTO schema_migrations (version) VALUES ('20161103011624');

INSERT INTO schema_migrations (version) VALUES ('20161218180745');

INSERT INTO schema_migrations (version) VALUES ('20161227160540');

INSERT INTO schema_migrations (version) VALUES ('20161227164831');

INSERT INTO schema_migrations (version) VALUES ('20161231035149');

INSERT INTO schema_migrations (version) VALUES ('20161231043448');

INSERT INTO schema_migrations (version) VALUES ('20170321042305');

INSERT INTO schema_migrations (version) VALUES ('20170321044226');

INSERT INTO schema_migrations (version) VALUES ('20170321044422');

INSERT INTO schema_migrations (version) VALUES ('20170525065802');

INSERT INTO schema_migrations (version) VALUES ('20180105121032');

INSERT INTO schema_migrations (version) VALUES ('20180124142305');

INSERT INTO schema_migrations (version) VALUES ('20180124151412');

INSERT INTO schema_migrations (version) VALUES ('20180124153301');

INSERT INTO schema_migrations (version) VALUES ('20180226033248');

