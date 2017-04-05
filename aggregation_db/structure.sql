--
-- PostgreSQL database dump
--

-- Dumped from database version 9.6.1
-- Dumped by pg_dump version 9.6.1

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
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


SET search_path = public, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: ar_internal_metadata; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE ar_internal_metadata (
    key character varying NOT NULL,
    value character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: email_active_user_rollups; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE email_active_user_rollups (
    id integer NOT NULL,
    day timestamp without time zone,
    day_total integer,
    thirty_day_total integer
);


--
-- Name: email_active_user_rollups_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE email_active_user_rollups_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: email_active_user_rollups_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE email_active_user_rollups_id_seq OWNED BY email_active_user_rollups.id;


--
-- Name: hourly_impressions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE hourly_impressions (
    id integer NOT NULL,
    starting_at timestamp without time zone,
    stream_kind character varying,
    stream_id character varying,
    logged_in_views integer,
    logged_out_views integer
);


--
-- Name: hourly_impressions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE hourly_impressions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: hourly_impressions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE hourly_impressions_id_seq OWNED BY hourly_impressions.id;


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE schema_migrations (
    version character varying NOT NULL
);


--
-- Name: email_active_user_rollups id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY email_active_user_rollups ALTER COLUMN id SET DEFAULT nextval('email_active_user_rollups_id_seq'::regclass);


--
-- Name: hourly_impressions id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY hourly_impressions ALTER COLUMN id SET DEFAULT nextval('hourly_impressions_id_seq'::regclass);


--
-- Name: ar_internal_metadata ar_internal_metadata_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY ar_internal_metadata
    ADD CONSTRAINT ar_internal_metadata_pkey PRIMARY KEY (key);


--
-- Name: email_active_user_rollups email_active_user_rollups_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY email_active_user_rollups
    ADD CONSTRAINT email_active_user_rollups_pkey PRIMARY KEY (id);


--
-- Name: hourly_impressions hourly_impressions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY hourly_impressions
    ADD CONSTRAINT hourly_impressions_pkey PRIMARY KEY (id);


--
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- Name: hourly_impressions_full_index; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX hourly_impressions_full_index ON hourly_impressions USING btree (starting_at, stream_kind, stream_id);


--
-- Name: index_email_active_user_rollups_on_day; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_email_active_user_rollups_on_day ON email_active_user_rollups USING btree (day);


--
-- PostgreSQL database dump complete
--

SET search_path TO "$user", public;

INSERT INTO schema_migrations (version) VALUES ('20170330144935'), ('20170404191344');


