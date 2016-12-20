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
-- Name: partman; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA partman;


--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


--
-- Name: pg_partman; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pg_partman WITH SCHEMA partman;


--
-- Name: EXTENSION pg_partman; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION pg_partman IS 'Extension to manage partitioned tables by time or ID';


SET search_path = public, pg_catalog;

--
-- Name: impressions_part_trig_func(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION impressions_part_trig_func() RETURNS trigger
    LANGUAGE plpgsql
    AS $_$
            DECLARE
            v_count                 int;
            v_partition_name        text;
            v_partition_timestamp   timestamptz;
        BEGIN 
        IF TG_OP = 'INSERT' THEN 
            v_partition_timestamp := date_trunc('day', NEW.created_at);
            IF NEW.created_at >= '2016-12-20 00:00:00+00' AND NEW.created_at < '2016-12-21 00:00:00+00' THEN 
            INSERT INTO public.impressions_p2016_12_20 VALUES (NEW.*) ; 
            ELSIF NEW.created_at >= '2016-12-19 00:00:00+00' AND NEW.created_at < '2016-12-20 00:00:00+00' THEN 
                INSERT INTO public.impressions_p2016_12_19 VALUES (NEW.*) ; 
            ELSIF NEW.created_at >= '2016-12-21 00:00:00+00' AND NEW.created_at < '2016-12-22 00:00:00+00' THEN 
                INSERT INTO public.impressions_p2016_12_21 VALUES (NEW.*) ;
            ELSIF NEW.created_at >= '2016-12-18 00:00:00+00' AND NEW.created_at < '2016-12-19 00:00:00+00' THEN 
                INSERT INTO public.impressions_p2016_12_18 VALUES (NEW.*) ; 
            ELSIF NEW.created_at >= '2016-12-22 00:00:00+00' AND NEW.created_at < '2016-12-23 00:00:00+00' THEN 
                INSERT INTO public.impressions_p2016_12_22 VALUES (NEW.*) ;
            ELSIF NEW.created_at >= '2016-12-17 00:00:00+00' AND NEW.created_at < '2016-12-18 00:00:00+00' THEN 
                INSERT INTO public.impressions_p2016_12_17 VALUES (NEW.*) ; 
            ELSIF NEW.created_at >= '2016-12-23 00:00:00+00' AND NEW.created_at < '2016-12-24 00:00:00+00' THEN 
                INSERT INTO public.impressions_p2016_12_23 VALUES (NEW.*) ;
            ELSIF NEW.created_at >= '2016-12-16 00:00:00+00' AND NEW.created_at < '2016-12-17 00:00:00+00' THEN 
                INSERT INTO public.impressions_p2016_12_16 VALUES (NEW.*) ; 
            ELSIF NEW.created_at >= '2016-12-24 00:00:00+00' AND NEW.created_at < '2016-12-25 00:00:00+00' THEN 
                INSERT INTO public.impressions_p2016_12_24 VALUES (NEW.*) ;
            ELSE
                v_partition_name := partman.check_name_length('impressions', to_char(v_partition_timestamp, 'YYYY_MM_DD'), TRUE);
                SELECT count(*) INTO v_count FROM pg_catalog.pg_tables WHERE schemaname = 'public'::name AND tablename = v_partition_name::name;
                IF v_count > 0 THEN 
                    EXECUTE format('INSERT INTO %I.%I VALUES($1.*) ', 'public', v_partition_name) USING NEW;
                ELSE
                    RETURN NEW;
                END IF;
            END IF;
        END IF;
        RETURN NULL;
        END $_$;


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
-- Name: impressions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE impressions (
    viewer_id character varying,
    post_id character varying NOT NULL,
    author_id character varying NOT NULL,
    created_at timestamp(4) without time zone NOT NULL
);


--
-- Name: impressions_by_days; Type: MATERIALIZED VIEW; Schema: public; Owner: -
--

CREATE MATERIALIZED VIEW impressions_by_days AS
 SELECT date_trunc('day'::text, impressions.created_at) AS day,
    count(1) AS ct
   FROM impressions
  GROUP BY (date_trunc('day'::text, impressions.created_at))
  WITH NO DATA;


--
-- Name: impressions_p2016_12_16; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE impressions_p2016_12_16 (
    viewer_id character varying,
    post_id character varying,
    author_id character varying,
    created_at timestamp(4) without time zone,
    CONSTRAINT impressions_p2016_12_16_partition_check CHECK (((created_at >= '2016-12-16 00:00:00'::timestamp without time zone) AND (created_at < '2016-12-17 00:00:00'::timestamp without time zone)))
)
INHERITS (impressions);


--
-- Name: impressions_p2016_12_17; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE impressions_p2016_12_17 (
    viewer_id character varying,
    post_id character varying,
    author_id character varying,
    created_at timestamp(4) without time zone,
    CONSTRAINT impressions_p2016_12_17_partition_check CHECK (((created_at >= '2016-12-17 00:00:00'::timestamp without time zone) AND (created_at < '2016-12-18 00:00:00'::timestamp without time zone)))
)
INHERITS (impressions);


--
-- Name: impressions_p2016_12_18; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE impressions_p2016_12_18 (
    viewer_id character varying,
    post_id character varying,
    author_id character varying,
    created_at timestamp(4) without time zone,
    CONSTRAINT impressions_p2016_12_18_partition_check CHECK (((created_at >= '2016-12-18 00:00:00'::timestamp without time zone) AND (created_at < '2016-12-19 00:00:00'::timestamp without time zone)))
)
INHERITS (impressions);


--
-- Name: impressions_p2016_12_19; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE impressions_p2016_12_19 (
    viewer_id character varying,
    post_id character varying,
    author_id character varying,
    created_at timestamp(4) without time zone,
    CONSTRAINT impressions_p2016_12_19_partition_check CHECK (((created_at >= '2016-12-19 00:00:00'::timestamp without time zone) AND (created_at < '2016-12-20 00:00:00'::timestamp without time zone)))
)
INHERITS (impressions);


--
-- Name: impressions_p2016_12_20; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE impressions_p2016_12_20 (
    viewer_id character varying,
    post_id character varying,
    author_id character varying,
    created_at timestamp(4) without time zone,
    CONSTRAINT impressions_p2016_12_20_partition_check CHECK (((created_at >= '2016-12-20 00:00:00'::timestamp without time zone) AND (created_at < '2016-12-21 00:00:00'::timestamp without time zone)))
)
INHERITS (impressions);


--
-- Name: impressions_p2016_12_21; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE impressions_p2016_12_21 (
    viewer_id character varying,
    post_id character varying,
    author_id character varying,
    created_at timestamp(4) without time zone,
    CONSTRAINT impressions_p2016_12_21_partition_check CHECK (((created_at >= '2016-12-21 00:00:00'::timestamp without time zone) AND (created_at < '2016-12-22 00:00:00'::timestamp without time zone)))
)
INHERITS (impressions);


--
-- Name: impressions_p2016_12_22; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE impressions_p2016_12_22 (
    viewer_id character varying,
    post_id character varying,
    author_id character varying,
    created_at timestamp(4) without time zone,
    CONSTRAINT impressions_p2016_12_22_partition_check CHECK (((created_at >= '2016-12-22 00:00:00'::timestamp without time zone) AND (created_at < '2016-12-23 00:00:00'::timestamp without time zone)))
)
INHERITS (impressions);


--
-- Name: impressions_p2016_12_23; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE impressions_p2016_12_23 (
    viewer_id character varying,
    post_id character varying,
    author_id character varying,
    created_at timestamp(4) without time zone,
    CONSTRAINT impressions_p2016_12_23_partition_check CHECK (((created_at >= '2016-12-23 00:00:00'::timestamp without time zone) AND (created_at < '2016-12-24 00:00:00'::timestamp without time zone)))
)
INHERITS (impressions);


--
-- Name: impressions_p2016_12_24; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE impressions_p2016_12_24 (
    viewer_id character varying,
    post_id character varying,
    author_id character varying,
    created_at timestamp(4) without time zone,
    CONSTRAINT impressions_p2016_12_24_partition_check CHECK (((created_at >= '2016-12-24 00:00:00'::timestamp without time zone) AND (created_at < '2016-12-25 00:00:00'::timestamp without time zone)))
)
INHERITS (impressions);


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE schema_migrations (
    version character varying NOT NULL
);


--
-- Name: ar_internal_metadata ar_internal_metadata_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY ar_internal_metadata
    ADD CONSTRAINT ar_internal_metadata_pkey PRIMARY KEY (key);


--
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- Name: impressions_p2016_12_16_created_at_author_id_post_id_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX impressions_p2016_12_16_created_at_author_id_post_id_idx ON impressions_p2016_12_16 USING btree (created_at, author_id, post_id);


--
-- Name: impressions_p2016_12_17_created_at_author_id_post_id_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX impressions_p2016_12_17_created_at_author_id_post_id_idx ON impressions_p2016_12_17 USING btree (created_at, author_id, post_id);


--
-- Name: impressions_p2016_12_18_created_at_author_id_post_id_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX impressions_p2016_12_18_created_at_author_id_post_id_idx ON impressions_p2016_12_18 USING btree (created_at, author_id, post_id);


--
-- Name: impressions_p2016_12_19_created_at_author_id_post_id_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX impressions_p2016_12_19_created_at_author_id_post_id_idx ON impressions_p2016_12_19 USING btree (created_at, author_id, post_id);


--
-- Name: impressions_p2016_12_20_created_at_author_id_post_id_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX impressions_p2016_12_20_created_at_author_id_post_id_idx ON impressions_p2016_12_20 USING btree (created_at, author_id, post_id);


--
-- Name: impressions_p2016_12_21_created_at_author_id_post_id_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX impressions_p2016_12_21_created_at_author_id_post_id_idx ON impressions_p2016_12_21 USING btree (created_at, author_id, post_id);


--
-- Name: impressions_p2016_12_22_created_at_author_id_post_id_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX impressions_p2016_12_22_created_at_author_id_post_id_idx ON impressions_p2016_12_22 USING btree (created_at, author_id, post_id);


--
-- Name: impressions_p2016_12_23_created_at_author_id_post_id_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX impressions_p2016_12_23_created_at_author_id_post_id_idx ON impressions_p2016_12_23 USING btree (created_at, author_id, post_id);


--
-- Name: impressions_p2016_12_24_created_at_author_id_post_id_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX impressions_p2016_12_24_created_at_author_id_post_id_idx ON impressions_p2016_12_24 USING btree (created_at, author_id, post_id);


--
-- Name: index_impressions_by_days_on_day; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_impressions_by_days_on_day ON impressions_by_days USING btree (day);


--
-- Name: index_impressions_on_created_at_and_author_id_and_post_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_impressions_on_created_at_and_author_id_and_post_id ON impressions USING btree (created_at, author_id, post_id);


--
-- Name: impressions impressions_part_trig; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER impressions_part_trig BEFORE INSERT ON impressions FOR EACH ROW EXECUTE PROCEDURE impressions_part_trig_func();


--
-- PostgreSQL database dump complete
--

SET search_path TO "$user", public;

INSERT INTO schema_migrations (version) VALUES ('20161017153308'), ('20161101113557'), ('20161208001535'), ('20161208200325'), ('20161208200518'), ('20161220042635'), ('20161220042637'), ('20161220045344'), ('20161220145823'), ('20161220154502'), ('20161220235101');


