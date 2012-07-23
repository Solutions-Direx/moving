SET statement_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


--
-- Name: unaccent; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS unaccent WITH SCHEMA public;


--
-- Name: EXTENSION unaccent; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION unaccent IS 'text search dictionary that removes accents';


SET search_path = public, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: pg_main
--

COPY users (id, username, first_name, last_name, active, email, encrypted_password, reset_password_token, reset_password_sent_at, remember_created_at, sign_in_count, current_sign_in_at, last_sign_in_at, current_sign_in_ip, last_sign_in_ip, created_at, updated_at, account_id, role, account_owner, localization) FROM stdin;
2	olivier	Olivier	Simart	t	olivier@yafoy.com	$2a$10$siScEQ4llURNvv3.HfsuKebFr0u20.XB7g63j1wqWbFk8T4GJoFrC	\N	\N	\N	12	2012-07-18 20:53:53.655225	2012-07-09 18:56:09.367829	70.26.235.107	88.121.95.155	2012-06-22 13:24:45.248202	2012-07-18 20:53:53.6565	1	manager	f	fr
12	acholette	Alexis	Cholette	t	acholette@demenagementmaximum.com	$2a$10$sEEASiGLfRUyH9b4iBegK./tL6W6daGSYSXX9LVr3Wsu8AbltzX52	\N	\N	\N	5	2012-07-19 15:07:26.800093	2012-07-09 15:11:05.698947	67.68.170.115	67.68.170.115	2012-06-22 19:02:20.084716	2012-07-19 15:07:26.801303	1	manager	f	fr
1	fgiroux	François	Giroux	t	fgiroux@demenagementmaximum.com	$2a$10$ZQvleCL8q5pOcCMaZL/a0uhXX1oIvv9yH5bgrzGUQLYsONW9nRRQO	\N	\N	\N	4	2012-06-22 13:12:58.400922	2012-06-22 07:43:34.56085	174.95.185.57	113.162.168.78	2012-06-22 05:29:22.166612	2012-06-22 13:25:25.949971	1	manager	t	fr
5	fsaumure	Francis	Saumure	t	fsaumure@demenagementmaximum.com	$2a$10$5CN/Vrbj01s9GC/0S6hUbuZw1UYJNSjLhMBDMepg0LQZWMiZ2Ta3a	\N	\N	\N	0	\N	\N	\N	\N	2012-06-22 17:13:00.44537	2012-06-22 17:13:00.44537	1	standard	f	fr
8	sroy	Stéphane	Roy	t	sroy@demenagementmaximum.com	$2a$10$2w.04.xRSQnEe8b4RYZAuet4lEgSP5v2mynERkPd4terIdClL38zO	\N	\N	\N	0	\N	\N	\N	\N	2012-06-22 17:14:51.214071	2012-06-22 17:14:51.214071	1	standard	f	fr
9	glarabi	Gaston	Larabie	t	glarabi@demenagementmaximum.com	$2a$10$JKNRiwA7BiBDzoucHbXVYOyzoA666kZ0OMQAlvLAIoM0s31KnuAMG	\N	\N	\N	0	\N	\N	\N	\N	2012-06-22 17:15:34.977135	2012-06-22 17:15:34.977135	1	standard	f	fr
10	demenageur1	Déménageur	Test1	t	demenageur@demenagementmaximum.com	$2a$10$CtBUdDPWTjKqMhDZrbSWnOhVSP8sBr1wKlSi6d.VucYH4t9qcl6we	\N	\N	\N	1	2012-06-22 18:03:21.730652	2012-06-22 18:03:21.730652	67.68.164.71	67.68.164.71	2012-06-22 18:00:19.087327	2012-06-26 18:01:52.568745	1	removal_man	f	fr
7	dmarquis	Dennis	Marquis	t	dmarquis@demenagementmaximum.com	$2a$10$yHj9h8X.kiTFanMF71TnjuIdO5OHvmHRSgJ088yQoIbJnYl6tnRU6	\N	\N	\N	3	2012-06-22 18:52:54.182172	2012-06-22 18:44:57.733533	67.68.164.71	67.68.164.71	2012-06-22 17:14:24.490906	2012-06-22 18:52:54.183173	1	manager	f	fr
6	ncaya	Nathalie	Caya	t	ncaya@demenagementmaximum.com	$2a$10$GOks8qUb5wjr5pwQNTXYAOSzGz2CqNIlsSTdzgd4Y6emfSJd1in5W	\N	\N	\N	1	2012-06-22 18:51:21.789497	2012-06-22 18:51:21.789497	67.68.164.71	67.68.164.71	2012-06-22 17:13:43.316212	2012-06-22 19:15:40.515219	1	manager	f	fr
11	mjdion	Marie-Josée	Dion	t	mjdion@demenagementmaximum.com	$2a$10$EzN6BE7DAeaUIjMDWKiq6O4DzOMPaWeoG1Z0g3ehmS6i0FsD2Bayi	\N	\N	\N	1	2012-06-22 19:56:43.286401	2012-06-22 19:56:43.286401	67.68.164.71	67.68.164.71	2012-06-22 19:01:33.927519	2012-06-22 19:57:43.082512	1	manager	f	fr
3	demenageur	Déménageur	Test	t	app@demenagementmaximum.com	$2a$10$wTqNC4AqrKZmZs3l7JQiROJZIuCgVGrgBB8xcRLDzsv44nFYyfdqu	\N	\N	\N	3	2012-06-26 12:32:31.748063	2012-06-22 17:09:51.555854	174.95.185.57	67.68.164.71	2012-06-22 13:31:38.451543	2012-06-26 12:32:31.749933	1	removal_man	f	fr
4	epichette	Érik	Pichette	t	epichette@demenagementmaximum.com	$2a$10$dZvZHTjiNvyRaLfNM.vDBeJf6gEDS63PKmYNoM4inAG5ohXCs0Ta6	\N	\N	2012-06-29 14:43:30.297108	2	2012-06-29 14:43:30.316021	2012-06-29 14:36:59.812888	67.68.164.71	67.68.164.71	2012-06-22 17:12:22.035849	2012-06-29 14:43:30.316625	1	manager	f	fr
\.

ALTER TABLE ONLY users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);