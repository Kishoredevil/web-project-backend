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
-- Name: user_login_attempts attempt_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_login_attempts ALTER COLUMN attempt_id SET DEFAULT nextval('public.user_login_attempts_attempt_id_seq'::regclass);


--
-- Data for Name: institution_master; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.institution_master (id, name, address, point_of_contact_first, point_of_contact_number_first, point_of_contact_email_id_first, point_of_contact_second, point_of_contact_number_second, point_of_contact_email_id_second, point_of_contact_third, point_of_contact_number_third, point_of_contact_email_id_third, parent_institution_id, affiliated_to, education_type, is_parent_institution, active) FROM stdin;
234561	SALESIAN INSTITUTE OF GRAPHIC ARTS	49, Taylors Road, Chennai	Fr. P.T. Joseph, SDB	9385201339	principal@sigaindia.com	\N	\N	\N	\N	\N	\N	123456	AICTE New Delhi	Polytechnic	N	Y
345621	DON BOSCO Arts & Science College	Angadikadavu P.O, Iritty, Kannur	Dr. Francis Karackat SDB	9961200787	dbascoffice@gmail.com	\N	\N	\N	\N	\N	\N	123456	University of Kannur in Kerala	Arts & Science	N	Y
131313	Arts & Science College	Angadikadavu P.O, Iritty, Kannur	Dr. Francis Karackat SDB	9961200787	dbascoffice@gmail.com	\N	\N	\N	\N	\N	\N	123456	University of Kannur in Kerala	Arts & Science	N	Y
212121	SALESIAN 	49, Taylors Road, Chennai	Fr. P.T. Joseph, SDB	9385201339	principal@sigaindia.com	\N	\N	\N	\N	\N	\N	123456	AICTE New Delhi	Polytechnic	N	Y
123456	DON BOSCO	Kilpauk, Chennai	Fr. P.T. Joseph, SDB	9385201339	principal@sigaindia.com	\N	9444076408	collegeoffice@sigaindia.com	\N	\N	\N	\N	Parent	Y	Y	\N
\.


--
-- Data for Name: login_details; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.login_details (id, username, password, email_id, secret_question_1_id, secret_answer_1, secret_question_2_id, secret_answer_2, institution_id, parent_institution_id, active, remarks) FROM stdin;
64	mohana@123	6021c1d18b450a2a84e586f09fdf1d5d	3dfbbc6e86c892ac413a565e42b9a9ca	2	1	1	2	234561	123456	t	\N
65	mohan@123	3545d0c472eb787d4e23d81ad48515a2	83df84bccbcfb5357fe2bd7f76cc5768	2	1	1	2	234561	123456	t	\N
66	Mohankrishnan@	5a5da0916a37b391ef71b3ad6bab6d33	6502ef04083a4758dd5eb48cdc17a990	3	1	3	1	234561	123456	t	\N
67	Mohankrishnan1@	5a5da0916a37b391ef71b3ad6bab6d33	6ba1a63057bc82d97e871c1b8de80552	2	1	1	2	234561	123456	t	\N
68	Mohankrishnan12	5a5da0916a37b391ef71b3ad6bab6d33	281d969e8c4aa9182868c685b8d1d16c	2	1	1	2	234561	123456	t	\N
69	Mohanskrishnan12	5a5da0916a37b391ef71b3ad6bab6d33	1c02f6d84c4a3d9a7a077038a8f1c821	2	1	1	2	131313	123456	t	\N
70	nroopeshkumar@gmail.com	3885491993feb0ef467c80b111f20efe	ba4bcb2b454d66da6807876a7d96e0e7	1	2	2	2	234561	123456	t	\N
71	Mohanakrishnan@	5a5da0916a37b391ef71b3ad6bab6d33	b5898f2b3d88056a1631308113a4668f	3	1	3	1	234561	123456	t	\N
\.


--
-- Data for Name: secret_questions; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.secret_questions (question_id, question_text, active, remarks) FROM stdin;
1	What was the name of your first pet?	A	\N
2	What is your favorite vacation destination?	A	\N
3	In which city did you have your first job?	A	\N
4	What was your favorite childhood book?	A	\N
5	Who was your favorite teacher in school?	A	\N
\.


--
-- Data for Name: user_login_attempts; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.user_login_attempts (attempt_id, user_id, login_timestamp, success, error_reason, ip_address, user_agent, username, email, "timestamp") FROM stdin;
19	69	2023-11-03 21:07:12.648+05:30	t	\N	192.168.29.166	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/119.0.0.0 Safari/537.36	\N	\N	\N
20	69	2023-11-03 21:08:10.967+05:30	t	\N	192.168.29.166	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/119.0.0.0 Safari/537.36	\N	\N	\N
21	69	2023-11-03 21:13:05.039+05:30	t	\N	192.168.29.166	vscode-restclient	\N	\N	\N
22	69	2023-11-03 21:15:04.606+05:30	t	\N	192.168.29.166	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/119.0.0.0 Safari/537.36	\N	\N	2023-11-03 21:15:04.606
23	69	2023-11-03 21:16:48.539+05:30	t	\N	192.168.29.166	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/119.0.0.0 Safari/537.36	Mohanskrishnan12	1c02f6d84c4a3d9a7a077038a8f1c821	2023-11-03 21:16:48.539
24	69	2023-11-03 21:18:46.322+05:30	t	\N	192.168.29.166	vscode-restclient	Mohanskrishnan12	1c02f6d84c4a3d9a7a077038a8f1c821	2023-11-03 21:18:46.322
25	69	2023-11-03 21:21:15.557+05:30	t	\N	192.168.29.166	vscode-restclient	Mohanskrishnan12	1c02f6d84c4a3d9a7a077038a8f1c821	2023-11-03 21:21:15.557
32	69	2023-11-03 21:31:41.271+05:30	t	\N	192.168.29.166	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/119.0.0.0 Safari/537.36	Mohanskrishnan12	1c02f6d84c4a3d9a7a077038a8f1c821	2023-11-03 21:31:41.271
36	69	2023-11-03 21:35:20.631+05:30	t	\N	192.168.29.166	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/119.0.0.0 Safari/537.36	Mohanskrishnan12	1c02f6d84c4a3d9a7a077038a8f1c821	2023-11-03 21:35:20.631
41	69	2023-11-03 21:37:22.272+05:30	t	\N	192.168.29.166	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/119.0.0.0 Safari/537.36	Mohanskrishnan12	1c02f6d84c4a3d9a7a077038a8f1c821	2023-11-03 21:37:22.272
47	69	2023-11-03 21:48:10.066+05:30	t	\N	192.168.29.166	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/119.0.0.0 Safari/537.36	Mohanskrishnan12	1c02f6d84c4a3d9a7a077038a8f1c821	2023-11-03 21:48:10.066
52	69	2023-11-03 22:03:48.631+05:30	t	\N	192.168.29.166	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/119.0.0.0 Safari/537.36	Mohanskrishnan12	1c02f6d84c4a3d9a7a077038a8f1c821	2023-11-03 22:03:48.631
53	69	2023-11-03 22:04:49.738+05:30	t	\N	192.168.29.166	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/119.0.0.0 Safari/537.36	Mohanskrishnan12	1c02f6d84c4a3d9a7a077038a8f1c821	2023-11-03 22:04:49.738
54	69	2023-11-04 13:18:39.386+05:30	t	\N	192.168.29.166	vscode-restclient	Mohanskrishnan12	1c02f6d84c4a3d9a7a077038a8f1c821	2023-11-04 13:18:39.386
59	\N	2023-11-04 13:25:55.397+05:30	f	Invalid User	192.168.29.166	vscode-restclient	Mohanskrishnan122	\N	2023-11-04 13:25:55.397
60	\N	2023-11-04 13:26:05.494+05:30	f	Invalid User	192.168.29.166	vscode-restclient	Mohanskrishnan122	\N	2023-11-04 13:26:05.494
61	\N	2023-11-04 13:26:26.458+05:30	f	Invalid User	192.168.29.166	vscode-restclient	Mohanskrishnan1	\N	2023-11-04 13:26:26.458
62	69	2023-11-04 13:26:41.452+05:30	t	\N	192.168.29.166	vscode-restclient	Mohanskrishnan12	1c02f6d84c4a3d9a7a077038a8f1c821	2023-11-04 13:26:41.452
63	\N	2023-11-04 13:27:42.055+05:30	f	Invalid User	192.168.29.166	vscode-restclient	nroopeshkumar@gmail.com	\N	2023-11-04 13:27:42.055
64	\N	2023-11-04 13:27:50.053+05:30	f	Invalid User	192.168.29.166	vscode-restclient	Mohanskrishnan12	\N	2023-11-04 13:27:50.053
65	\N	2023-11-04 13:31:42.968+05:30	f	Invalid User	192.168.29.166	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/119.0.0.0 Safari/537.36	Mohanakrishnan	\N	2023-11-04 13:31:42.968
66	\N	2023-11-04 13:33:01.979+05:30	f	Invalid User	192.168.29.166	vscode-restclient	Mohanskrishnan12	\N	2023-11-04 13:33:01.979
67	69	2023-11-04 13:33:06.551+05:30	t	true	192.168.29.166	vscode-restclient	Mohanskrishnan12	1c02f6d84c4a3d9a7a077038a8f1c821	2023-11-04 13:33:06.551
\.


--
-- Data for Name: user_sessions; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.user_sessions (session_id, user_id, login_timestamp, expiration_timestamp) FROM stdin;
eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJjY2JlIiwic3ViIjoxMzEzMTMsImF1ZCI6NjksImV4cCI6MTY5OTA1MDg4OSwiaWF0IjoxNjk5MDI5Mjg5LCJzY29wZSI6ImZ1bGwifQ.rTa0QRyCdvifETVGqo1QVb8GO6NaF8v7Z_gVpzjFfI4	69	2023-11-03 22:04:49.778	2023-11-04 04:04:49.778
eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJjY2JlIiwic3ViIjoxMzEzMTMsImF1ZCI6NjksImV4cCI6MTY5OTEwNTcxOSwiaWF0IjoxNjk5MDg0MTE5LCJzY29wZSI6ImZ1bGwifQ.yLjAlvB099Q7z_5RLxwjttZXQ5Sc_kGAaPKBuBAe6cc	69	2023-11-04 13:18:39.441	2023-11-04 19:18:39.441
eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJjY2JlIiwic3ViIjoxMzEzMTMsImF1ZCI6NjksImV4cCI6MTY5OTEwNjIwMSwiaWF0IjoxNjk5MDg0NjAxLCJzY29wZSI6ImZ1bGwifQ.T993Au7Qmwt6XiVLs-CTCjMoVkFNL9rjTQToHP7IxJ0	69	2023-11-04 13:26:41.498	2023-11-04 19:26:41.498
eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJjY2JlIiwic3ViIjoxMzEzMTMsImF1ZCI6NjksImV4cCI6MTY5OTEwNjU4NiwiaWF0IjoxNjk5MDg0OTg2LCJzY29wZSI6ImZ1bGwifQ.QiB0Z2O_9UG0YQu2BS71KY8Pz2r5N7gy4HE6WKDcXd8	69	2023-11-04 13:33:06.559	2023-11-04 19:33:06.559
\.


--
-- Name: login_details_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.login_details_id_seq', 71, true);


--
-- Name: secret_questions_question_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.secret_questions_question_id_seq', 5, true);


--
-- Name: user_login_attempts_attempt_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.user_login_attempts_attempt_id_seq', 67, true);


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
-- Name: user_sessions user_sessions_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_sessions
    ADD CONSTRAINT user_sessions_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.login_details(id);


--
-- PostgreSQL database dump complete
--

