--
-- PostgreSQL database dump
--

-- Dumped from database version 16.0
-- Dumped by pg_dump version 16.0

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: institution_master; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.institution_master (
    id integer NOT NULL,
    name character varying(255),
    address text,
    point_of_contact_first character varying(255),
    point_of_contact_number_first character varying(15),
    point_of_contact_email_id_first character varying(255),
    point_of_contact_second character varying(255),
    point_of_contact_number_second character varying(15),
    point_of_contact_email_id_second character varying(255),
    point_of_contact_third character varying(255),
    point_of_contact_number_third character varying(15),
    point_of_contact_email_id_third character varying(255),
    parent_institution_id integer,
    affiliated_to character varying(255),
    education_type character varying(255),
    is_parent_institution character(1),
    active character(1)
);


ALTER TABLE public.institution_master OWNER TO postgres;

--
-- Name: login_details; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.login_details (
    id integer NOT NULL,
    username character varying(50) NOT NULL,
    password character varying(100) NOT NULL,
    email_id character varying(100) NOT NULL,
    secret_question_1_id integer NOT NULL,
    secret_answer_1 character varying(100) NOT NULL,
    secret_question_2_id integer NOT NULL,
    secret_answer_2 character varying(100) NOT NULL,
    institution_id integer NOT NULL,
    parent_institution_id integer NOT NULL,
    active boolean DEFAULT true NOT NULL,
    remarks character varying(200)
);


ALTER TABLE public.login_details OWNER TO postgres;

--
-- Name: login_details_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.login_details_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.login_details_id_seq OWNER TO postgres;

--
-- Name: login_details_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.login_details_id_seq OWNED BY public.login_details.id;


--
-- Name: secret_questions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.secret_questions (
    question_id integer NOT NULL,
    question_text character varying(200) NOT NULL,
    active character(1) DEFAULT 'A'::bpchar,
    remarks character varying(200)
);


ALTER TABLE public.secret_questions OWNER TO postgres;

--
-- Name: secret_questions_question_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.secret_questions_question_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.secret_questions_question_id_seq OWNER TO postgres;

--
-- Name: secret_questions_question_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.secret_questions_question_id_seq OWNED BY public.secret_questions.question_id;


--
-- Name: templates_master; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.templates_master (
    id integer NOT NULL,
    name character varying(100) NOT NULL,
    institution_id integer NOT NULL,
    file_path character varying(200) NOT NULL,
    file_name character varying(100) NOT NULL,
    created_date timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    created_by character varying(100) DEFAULT 'SYSTEM'::character varying,
    modified_date timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    modified_by character varying(100) DEFAULT 'SYSTEM'::character varying,
    active boolean NOT NULL,
    remarks character varying(200)
);


ALTER TABLE public.templates_master OWNER TO postgres;

--
-- Name: templates_master_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.templates_master_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.templates_master_id_seq OWNER TO postgres;

--
-- Name: templates_master_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.templates_master_id_seq OWNED BY public.templates_master.id;


--
-- Name: user_login_attempts; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.user_login_attempts (
    attempt_id integer NOT NULL,
    user_id integer,
    login_timestamp timestamp with time zone NOT NULL,
    success boolean NOT NULL,
    error_reason character varying(500),
    ip_address character varying(100) NOT NULL,
    user_agent character varying(500) NOT NULL,
    username character varying(255),
    email character varying(255),
    "timestamp" timestamp without time zone
);


ALTER TABLE public.user_login_attempts OWNER TO postgres;

--
-- Name: user_login_attempts_attempt_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.user_login_attempts_attempt_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.user_login_attempts_attempt_id_seq OWNER TO postgres;

--
-- Name: user_login_attempts_attempt_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.user_login_attempts_attempt_id_seq OWNED BY public.user_login_attempts.attempt_id;


--
-- Name: user_sessions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.user_sessions (
    session_id character varying(250) NOT NULL,
    user_id integer NOT NULL,
    login_timestamp timestamp without time zone NOT NULL,
    expiration_timestamp timestamp without time zone NOT NULL
);


ALTER TABLE public.user_sessions OWNER TO postgres;

--
-- Name: login_details id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.login_details ALTER COLUMN id SET DEFAULT nextval('public.login_details_id_seq'::regclass);


--
-- Name: secret_questions question_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.secret_questions ALTER COLUMN question_id SET DEFAULT nextval('public.secret_questions_question_id_seq'::regclass);


--
-- Name: templates_master id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.templates_master ALTER COLUMN id SET DEFAULT nextval('public.templates_master_id_seq'::regclass);


--
-- Name: user_login_attempts attempt_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_login_attempts ALTER COLUMN attempt_id SET DEFAULT nextval('public.user_login_attempts_attempt_id_seq'::regclass);


--
-- Name: institution_master institution_master_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.institution_master
    ADD CONSTRAINT institution_master_pkey PRIMARY KEY (id);


--
-- Name: login_details login_details_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.login_details
    ADD CONSTRAINT login_details_pkey PRIMARY KEY (id);


--
-- Name: secret_questions secret_questions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.secret_questions
    ADD CONSTRAINT secret_questions_pkey PRIMARY KEY (question_id);


--
-- Name: templates_master templates_master_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.templates_master
    ADD CONSTRAINT templates_master_pkey PRIMARY KEY (id);


--
-- Name: user_login_attempts user_login_attempts_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_login_attempts
    ADD CONSTRAINT user_login_attempts_pkey PRIMARY KEY (attempt_id);


--
-- Name: user_sessions user_sessions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_sessions
    ADD CONSTRAINT user_sessions_pkey PRIMARY KEY (session_id);


--
-- Name: login_details login_details_institution_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.login_details
    ADD CONSTRAINT login_details_institution_id_fkey FOREIGN KEY (institution_id) REFERENCES public.institution_master(id);


--
-- Name: login_details login_details_parent_institution_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.login_details
    ADD CONSTRAINT login_details_parent_institution_id_fkey FOREIGN KEY (parent_institution_id) REFERENCES public.institution_master(id);


--
-- Name: login_details login_details_secret_question_1_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.login_details
    ADD CONSTRAINT login_details_secret_question_1_id_fkey FOREIGN KEY (secret_question_1_id) REFERENCES public.secret_questions(question_id);


--
-- Name: login_details login_details_secret_question_2_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.login_details
    ADD CONSTRAINT login_details_secret_question_2_id_fkey FOREIGN KEY (secret_question_2_id) REFERENCES public.secret_questions(question_id);


--
-- Name: templates_master templates_master_institution_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.templates_master
    ADD CONSTRAINT templates_master_institution_id_fkey FOREIGN KEY (institution_id) REFERENCES public.institution_master(id);


--
-- Name: user_sessions user_sessions_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_sessions
    ADD CONSTRAINT user_sessions_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.login_details(id);


--
-- PostgreSQL database dump complete
--

