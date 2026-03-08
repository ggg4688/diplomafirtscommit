--
-- PostgreSQL database dump
--

-- Dumped from database version 17.0
-- Dumped by pg_dump version 17.0

-- Started on 2026-03-09 03:21:51

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- TOC entry 2 (class 3079 OID 17624)
-- Name: pgcrypto; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pgcrypto WITH SCHEMA public;


--
-- TOC entry 4966 (class 0 OID 0)
-- Dependencies: 2
-- Name: EXTENSION pgcrypto; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION pgcrypto IS 'cryptographic functions';


--
-- TOC entry 3 (class 3079 OID 17751)
-- Name: uuid-ossp; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS "uuid-ossp" WITH SCHEMA public;


--
-- TOC entry 4967 (class 0 OID 0)
-- Dependencies: 3
-- Name: EXTENSION "uuid-ossp"; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION "uuid-ossp" IS 'generate universally unique identifiers (UUIDs)';


--
-- TOC entry 921 (class 1247 OID 17811)
-- Name: incident_status; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.incident_status AS ENUM (
    'open',
    'investigating',
    'resolved',
    'closed'
);


ALTER TYPE public.incident_status OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 222 (class 1259 OID 17708)
-- Name: alerts; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.alerts (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    event_id text,
    severity integer,
    message text,
    created_at timestamp without time zone DEFAULT now(),
    source_id uuid,
    asset_id uuid
);


ALTER TABLE public.alerts OWNER TO postgres;

--
-- TOC entry 220 (class 1259 OID 17672)
-- Name: assets; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.assets (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    hostname text NOT NULL,
    ip inet,
    os text,
    criticality integer DEFAULT 1,
    created_at timestamp without time zone DEFAULT now()
);


ALTER TABLE public.assets OWNER TO postgres;

--
-- TOC entry 223 (class 1259 OID 17722)
-- Name: incident_alerts; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.incident_alerts (
    incident_id uuid NOT NULL,
    alert_id uuid NOT NULL
);


ALTER TABLE public.incident_alerts OWNER TO postgres;

--
-- TOC entry 224 (class 1259 OID 17762)
-- Name: incident_comments; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.incident_comments (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    incident_id uuid NOT NULL,
    user_id uuid NOT NULL,
    comment text NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.incident_comments OWNER TO postgres;

--
-- TOC entry 225 (class 1259 OID 17781)
-- Name: incident_history; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.incident_history (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    incident_id uuid NOT NULL,
    user_id uuid NOT NULL,
    old_status text,
    new_status text,
    changed_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.incident_history OWNER TO postgres;

--
-- TOC entry 221 (class 1259 OID 17682)
-- Name: incidents; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.incidents (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    title text NOT NULL,
    description text,
    severity integer DEFAULT 1,
    status text DEFAULT 'new'::text,
    asset_id uuid,
    created_at timestamp without time zone DEFAULT now(),
    assigned_user_id uuid
);


ALTER TABLE public.incidents OWNER TO postgres;

--
-- TOC entry 219 (class 1259 OID 17661)
-- Name: users; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.users (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    email text NOT NULL,
    password_hash text NOT NULL,
    role text NOT NULL,
    created_at timestamp without time zone DEFAULT now()
);


ALTER TABLE public.users OWNER TO postgres;

--
-- TOC entry 4957 (class 0 OID 17708)
-- Dependencies: 222
-- Data for Name: alerts; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.alerts (id, event_id, severity, message, created_at, source_id, asset_id) FROM stdin;
\.


--
-- TOC entry 4955 (class 0 OID 17672)
-- Dependencies: 220
-- Data for Name: assets; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.assets (id, hostname, ip, os, criticality, created_at) FROM stdin;
\.


--
-- TOC entry 4958 (class 0 OID 17722)
-- Dependencies: 223
-- Data for Name: incident_alerts; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.incident_alerts (incident_id, alert_id) FROM stdin;
\.


--
-- TOC entry 4959 (class 0 OID 17762)
-- Dependencies: 224
-- Data for Name: incident_comments; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.incident_comments (id, incident_id, user_id, comment, created_at) FROM stdin;
\.


--
-- TOC entry 4960 (class 0 OID 17781)
-- Dependencies: 225
-- Data for Name: incident_history; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.incident_history (id, incident_id, user_id, old_status, new_status, changed_at) FROM stdin;
\.


--
-- TOC entry 4956 (class 0 OID 17682)
-- Dependencies: 221
-- Data for Name: incidents; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.incidents (id, title, description, severity, status, asset_id, created_at, assigned_user_id) FROM stdin;
\.


--
-- TOC entry 4954 (class 0 OID 17661)
-- Dependencies: 219
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.users (id, email, password_hash, role, created_at) FROM stdin;
\.


--
-- TOC entry 4793 (class 2606 OID 17716)
-- Name: alerts alerts_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.alerts
    ADD CONSTRAINT alerts_pkey PRIMARY KEY (id);


--
-- TOC entry 4789 (class 2606 OID 17681)
-- Name: assets assets_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.assets
    ADD CONSTRAINT assets_pkey PRIMARY KEY (id);


--
-- TOC entry 4795 (class 2606 OID 17726)
-- Name: incident_alerts incident_alerts_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.incident_alerts
    ADD CONSTRAINT incident_alerts_pkey PRIMARY KEY (incident_id, alert_id);


--
-- TOC entry 4797 (class 2606 OID 17770)
-- Name: incident_comments incident_comments_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.incident_comments
    ADD CONSTRAINT incident_comments_pkey PRIMARY KEY (id);


--
-- TOC entry 4799 (class 2606 OID 17789)
-- Name: incident_history incident_history_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.incident_history
    ADD CONSTRAINT incident_history_pkey PRIMARY KEY (id);


--
-- TOC entry 4791 (class 2606 OID 17692)
-- Name: incidents incidents_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.incidents
    ADD CONSTRAINT incidents_pkey PRIMARY KEY (id);


--
-- TOC entry 4785 (class 2606 OID 17671)
-- Name: users users_email_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key UNIQUE (email);


--
-- TOC entry 4787 (class 2606 OID 17669)
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- TOC entry 4802 (class 2606 OID 17800)
-- Name: alerts fk_alert_asset; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.alerts
    ADD CONSTRAINT fk_alert_asset FOREIGN KEY (asset_id) REFERENCES public.assets(id);


--
-- TOC entry 4800 (class 2606 OID 17805)
-- Name: incidents fk_incident_user; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.incidents
    ADD CONSTRAINT fk_incident_user FOREIGN KEY (assigned_user_id) REFERENCES public.users(id);


--
-- TOC entry 4803 (class 2606 OID 17732)
-- Name: incident_alerts incident_alerts_alert_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.incident_alerts
    ADD CONSTRAINT incident_alerts_alert_id_fkey FOREIGN KEY (alert_id) REFERENCES public.alerts(id);


--
-- TOC entry 4804 (class 2606 OID 17727)
-- Name: incident_alerts incident_alerts_incident_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.incident_alerts
    ADD CONSTRAINT incident_alerts_incident_id_fkey FOREIGN KEY (incident_id) REFERENCES public.incidents(id);


--
-- TOC entry 4805 (class 2606 OID 17771)
-- Name: incident_comments incident_comments_incident_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.incident_comments
    ADD CONSTRAINT incident_comments_incident_id_fkey FOREIGN KEY (incident_id) REFERENCES public.incidents(id) ON DELETE CASCADE;


--
-- TOC entry 4806 (class 2606 OID 17776)
-- Name: incident_comments incident_comments_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.incident_comments
    ADD CONSTRAINT incident_comments_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- TOC entry 4807 (class 2606 OID 17790)
-- Name: incident_history incident_history_incident_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.incident_history
    ADD CONSTRAINT incident_history_incident_id_fkey FOREIGN KEY (incident_id) REFERENCES public.incidents(id) ON DELETE CASCADE;


--
-- TOC entry 4808 (class 2606 OID 17795)
-- Name: incident_history incident_history_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.incident_history
    ADD CONSTRAINT incident_history_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- TOC entry 4801 (class 2606 OID 17693)
-- Name: incidents incidents_asset_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.incidents
    ADD CONSTRAINT incidents_asset_id_fkey FOREIGN KEY (asset_id) REFERENCES public.assets(id);


-- Completed on 2026-03-09 03:21:52

--
-- PostgreSQL database dump complete
--

