--
-- PostgreSQL database dump
--

-- Dumped from database version 9.6.22
-- Dumped by pg_dump version 12.7 (Ubuntu 12.7-0ubuntu0.20.04.1)

-- Started on 2021-08-09 20:02:58 CEST

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

--
-- TOC entry 187 (class 1259 OID 16465)
-- Name: test; Type: TABLE; Schema: public; Owner: cdg
--

CREATE TABLE public.test (
    id integer NOT NULL,
    start_timestamp timestamp without time zone NOT NULL,
    end_timestamp timestamp without time zone,
    user_id character varying NOT NULL,
    result character varying
);


ALTER TABLE public.test OWNER TO cdg;

--
-- TOC entry 186 (class 1259 OID 16463)
-- Name: test_id_seq; Type: SEQUENCE; Schema: public; Owner: cdg
--

CREATE SEQUENCE public.test_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.test_id_seq OWNER TO cdg;

--
-- TOC entry 2140 (class 0 OID 0)
-- Dependencies: 186
-- Name: test_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: cdg
--

ALTER SEQUENCE public.test_id_seq OWNED BY public.test.id;


--
-- TOC entry 2015 (class 2604 OID 16468)
-- Name: test id; Type: DEFAULT; Schema: public; Owner: cdg
--

ALTER TABLE ONLY public.test ALTER COLUMN id SET DEFAULT nextval('public.test_id_seq'::regclass);


--
-- TOC entry 2017 (class 2606 OID 16473)
-- Name: test test_pkey; Type: CONSTRAINT; Schema: public; Owner: cdg
--

ALTER TABLE ONLY public.test
    ADD CONSTRAINT test_pkey PRIMARY KEY (id);


-- Completed on 2021-08-09 20:02:58 CEST

--
-- PostgreSQL database dump complete
--

