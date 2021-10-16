--
-- PostgreSQL database dump
--

-- Dumped from database version 9.6.22
-- Dumped by pg_dump version 12.7 (Ubuntu 12.7-0ubuntu0.20.04.1)

-- Started on 2021-08-09 20:01:44 CEST

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
-- TOC entry 189 (class 1259 OID 16487)
-- Name: clue; Type: TABLE; Schema: public; Owner: cdg
--

CREATE TABLE public.clue (
    id integer NOT NULL,
    father_test integer NOT NULL,
    start_timestamp timestamp without time zone NOT NULL,
    end_timestamp timestamp without time zone,
    user_id character varying NOT NULL,
    file character varying,
    test_type character varying NOT NULL,
    result character varying,
    percentage numeric(5,4)
);


ALTER TABLE public.clue OWNER TO cdg;

--
-- TOC entry 188 (class 1259 OID 16485)
-- Name: clue_id_seq; Type: SEQUENCE; Schema: public; Owner: cdg
--

CREATE SEQUENCE public.clue_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.clue_id_seq OWNER TO cdg;

--
-- TOC entry 2141 (class 0 OID 0)
-- Dependencies: 188
-- Name: clue_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: cdg
--

ALTER SEQUENCE public.clue_id_seq OWNED BY public.clue.id;


--
-- TOC entry 2015 (class 2604 OID 16490)
-- Name: clue id; Type: DEFAULT; Schema: public; Owner: cdg
--

ALTER TABLE ONLY public.clue ALTER COLUMN id SET DEFAULT nextval('public.clue_id_seq'::regclass);


--
-- TOC entry 2017 (class 2606 OID 16495)
-- Name: clue clue_pkey; Type: CONSTRAINT; Schema: public; Owner: cdg
--

ALTER TABLE ONLY public.clue
    ADD CONSTRAINT clue_pkey PRIMARY KEY (id);


--
-- TOC entry 2018 (class 2606 OID 16496)
-- Name: clue test_clue_fk; Type: FK CONSTRAINT; Schema: public; Owner: cdg
--

ALTER TABLE ONLY public.clue
    ADD CONSTRAINT test_clue_fk FOREIGN KEY (father_test) REFERENCES public.test(id);


-- Completed on 2021-08-09 20:01:44 CEST

--
-- PostgreSQL database dump complete
--

