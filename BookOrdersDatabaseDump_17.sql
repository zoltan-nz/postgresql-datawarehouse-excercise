--
-- PostgreSQL database dump
--

SET statement_timeout = 0;
SET client_encoding = 'SQL_ASCII';
SET standard_conforming_strings = off;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET escape_string_warning = off;

--
-- Name: plpgsql; Type: PROCEDURAL LANGUAGE; Schema: -; Owner: pgsql
--

CREATE PROCEDURAL LANGUAGE plpgsql;


ALTER PROCEDURAL LANGUAGE plpgsql OWNER TO pgsql;

SET search_path = public, pg_catalog;

--
-- Name: plpgsql_call_handler(); Type: FUNCTION; Schema: public; Owner: pgsql
--

CREATE FUNCTION plpgsql_call_handler() RETURNS language_handler
    LANGUAGE c
    AS '$libdir/plpgsql', 'plpgsql_call_handler';


ALTER FUNCTION public.plpgsql_call_handler() OWNER TO pgsql;

SET default_tablespace = '';

SET default_with_oids = true;

--
-- Name: author; Type: TABLE; Schema: public; Owner: ; Tablespace: 
--

CREATE TABLE author (
    authorid integer NOT NULL,
    name character(15),
    surname character(15) NOT NULL
);


--
-- Name: book; Type: TABLE; Schema: public; Owner: ; Tablespace: 
--

CREATE TABLE book (
    isbn integer NOT NULL,
    title character(60) NOT NULL,
    edition_no smallint DEFAULT 1,
    price numeric(6,2) NOT NULL,
    CONSTRAINT book_edition_no CHECK ((edition_no > 0)),
    CONSTRAINT book_price CHECK ((price > (0)::numeric))
);


--
-- Name: book_author; Type: TABLE; Schema: public; Owner: ; Tablespace: 
--

CREATE TABLE book_author (
    isbn integer NOT NULL,
    authorid integer NOT NULL,
    authorseqno smallint DEFAULT 1,
    CONSTRAINT book_author_authorseqno CHECK ((authorseqno > 0))
);


--
-- Name: cust_order; Type: TABLE; Schema: public; Owner: ; Tablespace: 
--

CREATE TABLE cust_order (
    orderid integer NOT NULL,
    orderdate date NOT NULL,
    customerid integer NOT NULL ,
    CONSTRAINT cust_order_customerid CHECK ((customerid > 0)),
    CONSTRAINT cust_order_orderid CHECK ((orderid > 0))
);


--
-- Name: customer; Type: TABLE; Schema: public; Owner: ; Tablespace: 
--

CREATE TABLE customer (
    customerid integer NOT NULL,
    l_name character(20) NOT NULL,
    f_name character(20),
    city character(15) NOT NULL,
    district character(15) NOT NULL,
    country character(15) NOT NULL,
    CONSTRAINT customer_customerid CHECK ((customerid > 0))
);


--
-- Name: order_detail; Type: TABLE; Schema: public; Owner: ; Tablespace: 
--

CREATE TABLE order_detail (
    orderid integer NOT NULL,
    item_no smallint NOT NULL,
    isbn integer DEFAULT 0 NOT NULL,
    quantity smallint DEFAULT 1 NOT NULL,
    CONSTRAINT order_detail_item_no CHECK ((item_no > 0)),
    CONSTRAINT order_detail_orderid CHECK ((orderid > 0)),
    CONSTRAINT order_detail_quantity CHECK ((quantity > 0))
);



--
-- Data for Name: author; Type: TABLE DATA; Schema: public; Owner: 
--

COPY author (authorid, name, surname) FROM stdin;
1	Jafry          	Ullman         
2	Pavle          	Mogin          
3	Ramez          	Elmasri        
4	Shamkant       	Navathe        
5	Ivan           	Lukovic        
6	Miro           	Govedarica     
7	Michael        	Stonebraker    
8	Donald         	Moore          
9	William        	Inmon          
10	Rob            	Coronel        
11	Paul           	Beynon-Davies  
12	Raghu          	Ramakrishnan   
13	Johannes       	Gehrke         
14	Toby           	Teorey         
\.


--
-- Data for Name: book; Type: TABLE DATA; Schema: public; Owner: 
--

COPY book (isbn, title, edition_no, price) FROM stdin;
2222	Database Principles                                         	1	50.00
3333	Principles of Database and Knowledge-Base Systems           	1	100.00
4444	Principles of Database Systems                              	2	60.00
5555	Object_Relational DBMSs: The Next Great Wave                	1	75.00
6666	Principles of Database Design                               	1	65.00
7777	Readings in Database Systems                                	1	65.00
8888	Building the Data Warehouse                                 	1	80.00
1111	Fundamentals of Database Systems                            	3	75.00
1001	Database Management Systems                                 	2	95.00
2002	Database Systems                                            	2	90.00
3003	Database Systems                                            	4	100.00
4004	Database Modeling & Design                                  	2	70.00
\.


--
-- Data for Name: book_author; Type: TABLE DATA; Schema: public; Owner: 
--

COPY book_author (isbn, authorid, authorseqno) FROM stdin;
2222	2	1
2222	5	2
3333	1	1
1111	3	1
1111	4	2
4444	1	1
5555	7	1
5555	8	2
6666	2	1
6666	5	2
6666	6	3
7777	7	1
8888	9	1
1001	12	1
2002	11	1
3003	10	1
1001	13	2
4004	14	1
\.


--
-- Data for Name: cust_order; Type: TABLE DATA; Schema: public; Owner: 
--

COPY cust_order (orderid, orderdate, customerid) FROM stdin;
1	1998-03-01	1
2	1999-03-01	2
3	1999-03-01	3
4	1999-03-12	1
5	1999-03-08	1
6	1999-03-10	2
7	1999-03-12	4
8	1999-03-11	1
9	1999-03-09	2
10	1999-03-11	5
11	2000-03-09	5
12	2000-03-08	6
13	2000-03-09	2
14	2000-03-10	7
15	2000-03-08	3
16	2000-03-10	3
17	2000-03-11	8
18	2000-03-12	8
19	2000-03-21	1
20	2000-03-29	3
21	2001-03-28	1
22	2001-03-21	2
23	2001-03-20	2
24	2002-03-20	14
25	2002-03-20	15
26	2002-03-20	16
27	2002-03-20	17
29	1999-01-01	19
30	1999-01-01	20
31	1999-01-12	18
32	1999-02-08	18
33	1999-04-10	19
34	1999-05-12	21
35	1999-05-11	18
36	1999-07-09	19
37	1999-07-11	22
38	2002-07-09	22
39	2002-08-08	23
40	2002-09-09	22
41	2002-09-10	24
42	2002-09-08	20
43	2002-09-10	20
44	2002-09-11	25
45	2002-01-12	25
46	2000-01-21	18
47	2000-01-29	20
48	2001-02-28	18
49	2001-02-21	19
50	2001-06-20	19
28	1998-03-21	18
51	2002-03-20	31
52	2002-03-20	32
53	2002-03-20	33
54	2002-03-20	34
55	1999-01-01	28
56	1999-01-01	27
57	1999-01-12	26
58	1999-01-08	26
59	1999-01-10	27
60	1999-01-12	29
61	1999-01-11	26
62	1999-01-09	27
63	1999-01-11	30
64	2001-03-09	30
65	2001-03-08	35
66	2001-03-09	27
67	2001-03-10	36
68	2001-03-08	28
69	2001-03-10	28
70	2001-03-11	37
71	2001-03-12	37
72	2000-03-21	26
73	2000-03-29	3
74	2001-03-28	26
75	2001-03-21	27
76	2001-03-20	27
77	1998-03-01	26
78	2002-03-20	38
79	2002-03-20	39
80	2002-03-20	40
81	2002-03-20	41
82	2001-01-20	14
83	2002-08-09	14
84	2002-08-09	51
85	2002-03-20	14
86	2001-01-20	14
87	2002-08-09	14
88	2004-01-10	52
89	2004-01-12	53
90	2004-01-11	54
91	2004-01-09	55
92	2004-01-11	56
93	2004-03-09	57
94	2004-03-08	58
95	2004-03-09	58
96	2004-03-10	59
97	2004-03-08	60
98	2004-03-10	61
99	2004-03-11	62
100	2004-03-12	63
101	2004-03-21	64
102	2004-03-29	65
103	2004-03-28	66
104	2004-03-21	67
105	2004-03-20	67
106	2004-03-01	66
107	2004-03-20	1
108	2004-03-20	1
109	2004-03-20	3
110	2004-03-20	1
111	2004-01-20	1
112	2003-08-09	1
113	2003-08-09	3
114	2003-03-20	1
115	2003-01-20	3
116	2003-08-09	14
117	2001-03-01	68
118	2001-03-02	68
119	2001-03-03	69
120	2001-03-04	69
121	2001-03-05	70
122	2001-03-06	70
123	2001-03-07	71
124	2001-03-08	71
125	2001-03-09	72
126	2001-03-10	73
127	2001-03-11	73
128	2001-03-12	74
129	2001-03-13	74
130	2001-03-14	75
131	2001-03-15	75
132	2001-03-16	76
133	2001-03-17	76
134	2001-03-18	77
135	2001-03-19	77
136	2001-03-20	78
137	2001-03-21	78
138	2001-03-22	72
139	2001-03-23	79
140	2001-03-24	80
141	2001-03-25	80
142	2001-03-26	81
143	2001-03-27	81
144	2001-03-28	79
145	2001-03-29	79
146	2001-03-30	79
147	2001-03-30	82
148	2016-04-29	82
149	2016-04-30	83
150	2016-04-12	83
151	2016-04-13	84
152	2016-04-14	84
153	2016-04-15	85
154	2016-04-15	85
155	2016-04-16	86
156	2016-04-17	87
157	2016-04-18	87
158	2016-04-18	87
159	2016-04-19	88
160	2016-04-20	88
161	2016-04-21	89
162	2016-04-22	90
163	2016-04-22	90
164	2016-04-22	91
165	2016-04-23	91
166	2016-05-05	91
167	2016-05-05	92
168	2016-05-06	92
169	2016-05-06	93
170	2016-05-15	1
171	2016-05-15	93
172	2016-05-15	1
173	2017-04-29	94
174	2017-04-30	95
175	2017-04-12	96
176	2017-04-13	97
177	2017-04-14	98
178	2017-04-15	99
179	2017-04-15	100
180	2017-04-16	101
181	2017-04-17	102
182	2017-04-18	103
183	2017-04-18	104
184	2017-04-19	105
185	2017-04-20	106
186	2017-04-21	107
187	2017-04-22	108
188	2017-04-22	109
189	2017-04-22	110
190	2017-04-23	111
191	2017-05-05	112
192	2017-05-05	113
193	2017-05-06	114
194	2017-05-06	115
195	2017-05-15	116
196	2017-05-15	117
197	2017-05-15	118
198	2017-04-29	94
199	2017-04-30	94
200	2017-04-12	97
201	2017-04-13	97
202	2017-04-14	97
203	2017-04-15	100
204	2017-04-15	100
205	2017-04-16	103
206	2017-04-17	103
207	2017-04-18	103
208	2017-04-18	103
209	2017-04-19	106
210	2017-04-20	106
211	2017-04-21	106
212	2017-04-22	106
213	2017-04-22	106
214	2017-04-22	110
215	2017-04-23	113
216	2017-05-05	113
217	2017-05-05	115
218	2017-05-06	115
219	2017-05-06	115
220	2017-05-15	115
221	2017-05-15	117
222	2017-05-15	118
\.


--
-- Data for Name: customer; Type: TABLE DATA; Schema: public; Owner: 
--

COPY customer (customerid, l_name, f_name, city, district, country) FROM stdin;
1	Jacson              	Kirk                	Wellington     	Midland        	New Zealand    
2	Leow                	May-N               	Auckland       	Northland      	New Zealand    
3	Andree              	Peter               	Lower Hutt     	Midland        	New Zealand    
4	Noble               	James               	Wellington     	Midland        	New Zealand    
5	Tempero             	Ewan                	Auckland       	Northland      	New Zealand    
6	Anderson            	Svend               	Christchurch   	Southland      	New Zealand    
7	Nickson             	Ray                 	Brisbane       	Quinsland      	Australia      
8	Dobbie              	Gill                	Auckland       	Northland      	New Zealand    
9	Martin              	Paul                	Melbourne      	Victoria       	Australia      
10	Barmouta            	Alex                	Upper Hutt     	Midland        	New Zealand    
11	Xu                  	Gang                	Lower Hutt     	Midland        	New Zealand    
12	McMurray            	Linda               	Wellington     	Midland        	New Zealand    
13	Somerfield          	Nigel               	Sidney         	New South Wales	Australia      
14	Anslow              	Craig               	Wellington     	Midland        	New Zealand    
15	Gandhi              	Amit                	Madras         	Madras         	India          
16	Yi                  	Shusen              	Wuhan          	Hubei          	China          
17	Zhung               	Daisy               	Baoding        	Hebei          	China          
18	Al-Dabbagh          	Ahmed               	Melbourne      	Victoria       	Australia      
19	Gautam              	Sumit Pani          	Mumbai         	Maharashtra    	India          
20	Ballinger           	Daniel              	Auckland       	Northland      	New Zealand    
21	Bi                  	Chai Hong           	Wuhan          	Hubei          	China          
22	Chen                	Po-Han              	Porirua        	Midland        	New Zealand    
23	Choong              	Siong Loong         	Lower Hutt     	Midland        	New Zealand    
24	Lin                 	Quitang             	Baoding        	Hebei          	China          
25	Compton             	Philip              	Melbourne      	Victoria       	Australia      
26	Croad               	Nicolas             	Christchurch   	Southland      	New Zealand    
27	Deng                	Jian Ye             	Wuhan          	Hubei          	China          
28	Dontikurthi         	Udaya Venkata       	Mumbai         	Maharashtra    	India          
29	Fitzpatrick         	Kirk                	Dunedin        	Southland      	New Zealand    
30	Gaskin              	Ben                 	Sidney         	New South Wales	Australia      
31	Chopra              	Ankit               	Calcutta       	West Bengal    	India          
32	Kruchio             	Ferenc              	Sidney         	New South Wales	Australia      
33	Lu                  	Feng                	Baoding        	Hebei          	China          
34	Pritchard           	Mark                	Dunedin        	Southland      	New Zealand    
35	Ren                 	Shu Yi              	Wuhan          	Hubei          	China          
36	Robinson            	Grant               	Auckland       	Northland      	New Zealand    
37	Rowhani             	Ramez               	Porirua        	Midland        	New Zealand    
38	Suratman            	Gusmoko             	Upper Hutt     	Midland        	New Zealand    
39	Tian                	Zhuang              	Baoding        	Hebei          	China          
40	Vijay               	Pavithra            	Calcutta       	West Bengal    	India          
41	Wang                	Ming                	Wuhan          	Hubei          	China          
42	Wang                	Yang                	Wuhan          	Hubei          	China          
43	Xu                  	Yi Su               	Beijing        	Beijing        	China          
44	Zhang               	Hao Sheng           	Wuhan          	Hubei          	China          
45	Lu                  	Fan                 	Beijing        	Beijing        	China          
46	Gundlapalle         	Sudharshan          	Mumbai         	Maharashtra    	India          
47	Jonston             	Lindsay             	Brisbane       	Quinsland      	Australia      
48	Yang                	Yang                	Wuhan          	Hubei          	China          
49	Jiang               	Ling                	Wuhan          	Hubei          	China          
50	Groves              	Lindsay             	Porirua        	Midland        	New Zealand    
51	Hine                	John                	Wellington     	Midland        	New Zealand    
52	Adyanthaya          	Pushparaj           	Mumbai         	Maharashtra    	India          
53	Brassell            	Steven              	Porirua        	Midland        	New Zealand    
54	Chan                	Colin               	Upper Hutt     	Midland        	New Zealand    
55	Chandrasekharan     	Nithya              	Calcutta       	West Bengal    	India          
56	Vijay               	Pavithra            	Calcutta       	West Bengal    	India          
57	Crabtree            	Daniel              	Brisbane       	Quinsland      	Australia      
58	Haugvaldstad        	Erik                	Wellington     	Midland        	New Zealand    
59	Ferreira            	Jennifer            	Christchurch   	Southland      	New Zealand    
60	Lankupalli          	Venkatraman         	Madras         	Madras         	India          
61	Longhurst           	Alan                	Auckland       	Northland      	New Zealand    
62	Powel               	Brooks              	Upper Hutt     	Midland        	New Zealand    
63	Walter              	Christine           	Tubingen       	Baden Wurtemb  	Germany        
64	Wojnar              	Maciej              	Upper Hutt     	Midland        	New Zealand    
65	Woodman             	Michael             	Melbourne      	Victoria       	Australia      
66	Yang                	Jie                 	Wuhan          	Hubei          	China          
67	Zhang               	Yun                 	Beijing        	Beijing        	China          
68	Adams               	Toni                	Auckland       	Northland      	New Zealand    
69	Costantini          	Marco               	Auckland       	Northland      	New Zealand    
70	Culen               	Joshua              	Porirua        	Midland        	New Zealand    
71	Vechsamutavaree     	Panrawee            	Porirua        	Midland        	New Zealand    
72	Thaufeeg            	Ashfag              	Christchurch   	Southland      	New Zealand    
73	McArthur            	Blair               	Christchurch   	Southland      	New Zealand    
74	Lawrence            	Joe                 	Mumbai         	Maharashtra    	India          
75	Mathur              	Abhishek            	Mumbai         	Maharashtra    	India          
76	Wang                	Peng                	Sidney         	New South Wales	Australia    
77	Worawitphinyo       	Phiradit            	Sidney         	New South Wales	Australia    
78	Liu                 	Xu                  	Wellington     	Midland        	New Zealand    
79	Liang               	Jiajun              	Wellington     	Midland        	New Zealand    
80	Zhang               	Bingquam            	Wuhan          	Hubei          	China          
81	Wang                	Rui                 	Wuhan          	Hubei          	China          
82	Bai                 	XiaoHan             	Beijing        	Haidian        	China          
83	Chung               	Alex                	Wellington     	Midland        	New Zealand          
84	Ebue                	Ryian               	Upper Hutt     	Midland        	New Zealand          
85	French              	Lucy                	Wellington     	Midland        	New Zealand          
86	Gu                  	Linfeng             	Shanghai       	Jinshan        	China          
87	Yi                  	Liu                 	Beijing        	Haidian        	China          
88	Moshi               	Ewan                	Wellington     	Midland        	New Zealand          
89	Ng                  	Amon                	Wellington     	Midland        	New Zealand
90	Peesapati           	Venkata             	Wellington     	Midland        	New Zealand
91	Rutter              	Bradley             	Wellington     	Midland        	New Zealand
92	Selvin_Smith        	Ben                 	Wellington     	Midland        	New Zealand
93	Surendran           	Dany                	Wellington     	Midland        	New Zealand
94	Barapatre           	Shweta              	Auckland       	Northland      	New Zealand    
95	Bhula               	Priyanka            	Auckland       	Northland      	New Zealand    
96	Bogoievski          	Jovan               	Skopje         	Midland        	Macedonia    
97	Bryers              	Cameron             	Porirua        	Midland        	New Zealand    
98	Chan                	Valerie             	Christchurch   	Southland      	New Zealand    
99	Cooper              	Nathan              	Christchurch   	Southland      	New Zealand    
100	Debre               	Zoltan              	Budapest       	               	Hungary          
101	Evans               	Benjamin            	Mumbai         	Maharashtra    	India          
102	Jamdar              	Leila               	Sidney         	New South Wales	Australia    
103	Jariwala            	Mansi               	Sidney         	New South Wales	Australia    
104	Javaher             	Mansour             	Wellington     	Midland        	New Zealand    
105	Li                  	Jessie              	Wuhan          	Hubei          	China    
106	Li                  	Li                  	Wuhan          	Hubei          	China          
107	Pan                 	Xiaoxing            	Beijing        	Haidian        	China          
108	Pang                	Aaron               	Lower Hutt     	Midland        	New Zealand          
109	Petel               	Neel                	Wellington     	Midland        	New Zealand          
110	Perez               	Ronni               	Upper Hutt     	Midland        	New Zealand          
111	Semila              	Kaszandra           	Wellington     	Midland        	New Zealand          
112	Shaikh              	Bilal               	Porirua        	Midland        	New Zealand          
113	Shi                 	Tao                 	Auckland       	Northland      	New Zealand    
114	Singh               	Harman              	Wellington     	Midland        	New Zealand          
115	Tofts               	Christopher         	Christchurch   	Southland      	New Zealand
116	Wu                  	Adrian              	Beijing        	Haidian        	China
117	Yang                	Lei                 	Wuhan          	Hubei          	China
118	Yska                	Daniel              	Masterton     	Midland        	New Zealand
\.


--
-- Data for Name: order_detail; Type: TABLE DATA; Schema: public; Owner: 
--

COPY order_detail (orderid, item_no, isbn, quantity) FROM stdin;
1	1	2222	1
1	2	4444	2
1	3	6666	2
1	4	8888	1
1	5	1111	1
1	6	1001	1
1	7	2002	1
1	8	3003	1
1	9	4004	1
1	10	5555	1
2	1	1111	10
2	2	3333	1
2	3	5555	1
2	4	7777	1
2	5	2222	1
2	6	4444	1
2	7	6666	1
2	8	8888	1
2	9	1001	1
2	10	3003	1
3	1	5555	1
3	2	7777	1
3	3	2222	1
3	4	4444	1
3	5	6666	1
3	6	1111	1
3	7	3333	1
3	8	1001	1
3	9	2002	1
3	10	3003	1
4	1	2222	1
4	2	1111	1
4	3	3333	1
4	4	5555	1
4	5	7777	1
4	6	4444	1
4	7	6666	1
4	8	8888	1
4	9	1001	1
4	10	2002	1
4	11	3003	1
4	12	4004	1
5	1	2222	1
5	2	2002	1
5	3	1001	1
5	4	1111	1
5	5	3333	1
5	6	5555	1
5	7	7777	1
5	8	4444	1
5	9	6666	1
5	10	8888	1
5	11	3003	1
5	12	4004	1
6	1	2222	1
6	2	2002	1
6	3	1001	1
6	4	3003	1
6	5	4004	1
6	6	4444	1
6	7	6666	1
6	8	8888	1
6	9	1111	1
6	10	3333	1
7	1	2222	1
7	2	8888	3
7	3	4444	3
7	4	6666	3
7	5	2002	3
7	6	4004	3
7	7	1111	3
7	8	3333	3
7	9	5555	3
7	10	7777	3
7	11	1001	3
8	1	2222	1
8	2	8888	1
8	3	4004	1
8	4	3003	1
8	5	1001	1
8	6	2002	3
8	7	1111	1
8	8	3333	3
8	9	5555	1
8	10	7777	1
8	11	6666	1
9	1	2222	1
9	2	1001	1
9	3	4004	1
9	4	3003	1
9	5	2002	1
9	6	4444	3
9	7	1111	1
9	8	3333	3
9	9	5555	1
9	10	7777	1
9	11	6666	1
10	1	2222	3
10	2	3003	2
10	3	4004	5
10	4	2002	1
10	5	1001	1
10	6	4444	3
10	7	1111	1
10	8	3333	3
10	9	5555	1
10	10	7777	1
10	11	8888	5
11	1	2222	1
11	2	6666	1
11	3	3003	1
11	4	2002	1
11	5	1001	1
11	6	4004	3
11	7	1111	1
11	8	3333	3
11	9	5555	1
11	10	7777	1
11	11	4444	5
12	1	7777	1
12	2	1111	1
12	3	1001	1
12	4	3003	1
12	5	2002	1
12	6	4004	3
12	7	2222	1
12	8	3333	3
12	9	5555	4
12	10	4444	1
12	11	6666	5
13	1	2222	1
13	2	2002	1
13	3	5555	1
13	4	3003	1
13	5	1001	1
13	6	4004	3
13	7	1111	1
13	8	3333	3
13	9	4444	1
13	10	7777	1
13	11	6666	5
14	1	4444	1
14	2	2002	2
14	3	6666	1
14	4	3003	1
14	5	1001	1
14	6	4004	3
14	7	1111	1
14	8	3333	3
14	9	5555	1
14	10	7777	1
14	11	8888	5
15	1	6666	1
15	2	8888	4
15	3	3003	1
15	4	1001	1
15	5	4004	3
15	6	1111	1
15	7	3333	3
15	8	5555	1
15	9	7777	1
15	10	2222	5
16	1	8888	1
16	2	1111	1
16	3	1001	1
16	4	3003	1
16	5	2002	1
16	6	4004	3
16	7	2222	1
16	8	3333	3
16	9	5555	1
16	10	7777	1
16	11	4444	5
17	1	2222	1
17	2	2002	1
17	3	4004	1
17	4	3003	1
17	5	1001	1
17	6	4444	3
17	7	1111	1
17	8	3333	3
17	9	5555	1
17	10	7777	1
17	11	6666	5
18	1	1111	1
18	2	1001	1
18	3	3003	1
18	4	2002	1
18	5	4004	3
18	6	2222	1
18	7	3333	3
18	8	5555	1
18	9	7777	1
18	10	4444	5
19	1	2222	1
19	2	4444	1
19	3	6666	1
19	4	2002	1
19	5	3003	1
19	6	1001	1
19	7	4004	3
19	8	1111	1
19	9	3333	3
19	10	5555	1
20	1	2222	1
20	2	4444	1
20	3	6666	1
20	4	3003	1
20	5	1001	1
20	6	4004	3
20	7	1111	1
20	8	3333	3
20	9	5555	1
20	10	7777	1
20	11	2002	5
21	1	4444	1
21	2	4004	1
21	3	7777	1
21	4	5555	1
21	5	1111	1
21	6	2222	1
23	1	1111	1
23	2	2222	1
23	3	7777	1
23	4	3003	1
23	5	1001	1
23	6	4004	3
23	7	4444	1
23	8	3333	3
23	9	5555	1
23	10	6666	1
23	11	2002	5
22	1	1111	1
22	2	3333	1
22	3	5555	1
22	4	7777	1
22	5	2222	1
22	6	4444	1
22	7	6666	1
22	8	8888	1
22	9	1001	1
22	10	3003	1
24	1	6666	21
25	1	6666	21
26	1	6666	21
27	1	6666	21
28	1	2222	1
28	2	4444	2
29	1	6666	2
29	2	8888	1
30	1	1111	1
30	2	1001	1
31	1	2002	1
31	2	3003	1
32	1	4004	1
32	2	5555	1
33	1	1111	10
33	2	3333	1
34	1	5555	1
34	2	7777	1
35	1	2222	1
36	1	4444	1
37	1	6666	1
38	1	8888	1
39	1	1001	1
39	2	3003	1
40	1	5555	1
41	1	7777	1
41	2	2222	1
41	3	4444	1
42	1	6666	1
43	1	1111	1
43	2	3333	1
43	3	1001	1
43	4	2002	1
44	1	3003	1
44	2	2222	1
45	1	1111	1
45	2	3333	1
46	1	5555	1
47	1	7777	1
47	2	4444	1
47	3	6666	1
48	1	8888	1
49	1	1001	1
49	2	2002	1
50	1	3003	1
50	2	4004	1
51	1	2222	1
52	1	2002	1
52	2	1001	1
52	3	1111	1
52	4	3333	1
53	1	5555	1
54	1	7777	1
54	2	4444	1
55	1	6666	1
55	2	8888	1
55	3	3003	1
56	1	4004	1
57	1	2222	1
58	1	2002	1
59	1	1001	1
60	1	3003	1
60	2	4004	1
61	1	4444	1
62	1	6666	1
63	1	8888	1
64	1	1111	1
65	1	3333	1
66	1	2222	1
66	2	8888	3
66	3	4444	3
67	1	6666	3
67	2	2002	3
68	1	4004	3
69	1	1111	3
70	1	3333	3
70	2	5555	3
71	1	7777	3
72	1	1001	3
73	1	3333	3
73	2	5555	3
74	1	7777	3
75	1	1001	3
76	1	3333	3
76	2	5555	3
77	1	7777	3
78	1	1001	3
79	1	3333	3
79	2	5555	3
80	1	7777	3
80	2	1001	3
82	1	2222	1
82	2	8888	1
82	3	4004	1
82	4	3003	1
82	5	1001	1
82	6	2002	3
82	7	1111	1
82	8	3333	3
82	9	5555	1
82	10	7777	1
82	11	6666	1
81	1	2222	1
81	2	8888	1
81	3	4004	1
81	4	3003	1
81	5	1001	1
81	6	2002	3
81	7	1111	1
81	8	3333	3
81	9	5555	1
81	10	7777	1
81	11	6666	1
83	1	6666	25
83	2	7777	13
83	3	1111	33
84	1	1111	13
85	1	6666	11
86	1	7777	12
87	1	1111	13
88	1	1001	3
88	2	3333	3
89	1	5555	3
89	2	7777	3
90	1	1001	3
91	1	3333	3
92	1	5555	3
92	2	7777	3
93	1	1001	3
94	1	2222	1
95	1	8888	1
96	1	4004	1
96	2	3003	1
96	3	1001	1
97	1	2002	3
98	1	1111	1
99	1	3333	3
100	1	5555	1
100	2	7777	1
101	1	6666	1
102	1	2222	1
103	1	8888	1
104	1	4004	1
104	2	3003	1
104	3	1001	1
104	4	2002	3
104	5	1111	1
105	1	3333	3
105	2	5555	1
106	1	7777	1
107	1	6666	1
107	2	6666	25
107	3	7777	13
108	1	1111	33
108	2	1111	13
108	3	6666	11
109	1	7777	12
109	2	1111	13
109	3	1001	3
109	4	3333	3
110	1	5555	3
110	2	7777	3
110	3	1001	3
110	4	3333	3
110	5	5555	3
110	6	7777	3
110	7	1001	3
110	8	2222	1
110	9	8888	1
110	10	4004	1
111	1	3003	1
111	2	1001	1
111	3	2002	3
111	4	1111	1
111	5	3333	3
111	6	5555	1
112	1	7777	1
112	2	6666	1
112	3	2222	1
112	4	8888	1
113	1	4004	1
113	2	3003	1
113	3	1001	1
113	4	2002	3
113	5	1111	1
113	6	3333	3
114	1	5555	1
114	2	7777	1
114	3	6666	1
114	4	6666	25
115	1	7777	13
115	2	1111	33
115	3	1111	13
115	4	6666	11
116	1	7777	12
116	2	1111	13
117	1	2222	1
117	2	4444	2
117	3	6666	2
117	4	8888	1
117	5	1111	1
117	6	1001	1
117	7	2002	1
117	8	3003	1
117	9	4004	1
117	10	5555	1
118	1	1111	10
118	2	3333	1
118	3	5555	1
118	4	7777	1
118	5	2222	1
118	6	4444	1
118	7	6666	1
118	8	8888	1
118	9	1001	1
118	10	3003	1
119	1	5555	1
119	2	7777	1
119	3	2222	1
119	4	4444	1
119	5	6666	1
119	6	1111	1
119	7	3333	1
119	8	1001	1
119	9	2002	1
119	10	3003	1
120	1	2222	1
120	2	1111	1
120	3	3333	1
120	4	5555	1
120	5	7777	1
120	6	4444	1
120	7	6666	1
120	8	8888	1
120	9	1001	1
120	10	2002	1
120	11	3003	1
120	12	4004	1
121	1	2222	1
121	2	2002	1
121	3	1001	1
121	4	1111	1
121	5	3333	1
121	6	5555	1
121	7	7777	1
121	8	4444	1
121	9	6666	1
121	10	8888	1
121	11	3003	1
121	12	4004	1
122	1	2222	1
122	2	2002	1
122	3	1001	1
122	4	3003	1
122	5	4004	1
122	6	4444	1
122	7	6666	1
122	8	8888	1
122	9	1111	1
122	10	3333	1
123	1	2222	1
123	2	8888	3
123	3	4444	3
123	4	6666	3
123	5	2002	3
123	6	4004	3
123	7	1111	3
123	8	3333	3
123	9	5555	3
123	10	7777	3
123	11	1001	3
124	1	2222	1
124	2	8888	1
124	3	4004	1
124	4	3003	1
124	5	1001	1
124	6	2002	3
124	7	1111	1
124	8	3333	3
124	9	5555	1
124	10	7777	1
124	11	6666	1
125	1	2222	1
125	2	1001	1
125	3	4004	1
125	4	3003	1
125	5	2002	1
125	6	4444	3
125	7	1111	1
125	8	3333	3
125	9	5555	1
125	10	7777	1
125	11	6666	1
126	1	2222	3
126	2	3003	2
126	3	4004	5
126	4	2002	1
126	5	1001	1
126	6	4444	3
126	7	1111	1
126	8	3333	3
126	9	5555	1
126	10	7777	1
126	11	8888	5
127	1	2222	1
127	2	6666	1
127	3	3003	1
127	4	2002	1
127	5	1001	1
127	6	4004	3
127	7	1111	1
127	8	3333	3
127	9	5555	1
127	10	7777	1
127	11	4444	5
128	1	7777	1
128	2	1111	1
128	3	1001	1
128	4	3003	1
128	5	2002	1
128	6	4004	3
128	7	2222	1
128	8	3333	3
128	9	5555	4
128	10	4444	1
128	11	6666	5
129	1	2222	1
129	2	2002	1
129	3	5555	1
129	4	3003	1
129	5	1001	1
129	6	4004	3
129	7	1111	1
129	8	3333	3
129	9	4444	1
129	10	7777	1
129	11	6666	5
130	1	4444	1
130	2	2002	2
130	3	6666	1
130	4	3003	1
130	5	1001	1
130	6	4004	3
130	7	1111	1
130	8	3333	3
130	9	5555	1
130	10	7777	1
130	11	8888	5
131	1	6666	1
131	2	8888	4
131	3	3003	1
131	4	1001	1
131	5	4004	3
131	6	1111	1
131	7	3333	3
131	8	5555	1
131	9	7777	1
131	10	2222	5
132	1	2222	1
132	2	4444	2
132	3	6666	2
132	4	8888	1
132	5	1111	1
132	6	1001	1
132	7	2002	1
132	8	3003	1
132	9	4004	1
132	10	5555	1
133	1	1111	10
133	2	3333	1
133	3	5555	1
133	4	7777	1
133	5	2222	1
133	6	4444	1
133	7	6666	1
133	8	8888	1
133	9	1001	1
133	10	3003	1
134	1	5555	1
134	2	7777	1
134	3	2222	1
134	4	4444	1
134	5	6666	1
134	6	1111	1
134	7	3333	1
134	8	1001	1
134	9	2002	1
134	10	3003	1
135	1	2222	1
135	2	1111	1
135	3	3333	1
135	4	5555	1
135	5	7777	1
135	6	4444	1
135	7	6666	1
135	8	8888	1
135	9	1001	1
135	10	2002	1
135	11	3003	1
135	12	4004	1
136	1	2222	1
136	2	2002	1
136	3	1001	1
136	4	1111	1
136	5	3333	1
136	6	5555	1
136	7	7777	1
136	8	4444	1
136	9	6666	1
136	10	8888	1
136	11	3003	1
136	12	4004	1
137	1	2222	1
137	2	2002	1
137	3	1001	1
137	4	3003	1
137	5	4004	1
137	6	4444	1
137	7	6666	1
137	8	8888	1
137	9	1111	1
137	10	3333	1
138	1	2222	1
138	2	8888	3
138	3	4444	3
138	4	6666	3
138	5	2002	3
138	6	4004	3
138	7	1111	3
138	8	3333	3
138	9	5555	3
138	10	7777	3
138	11	1001	3
139	1	2222	1
139	2	8888	1
139	3	4004	1
139	4	3003	1
139	5	1001	1
139	6	2002	3
139	7	1111	1
139	8	3333	3
139	9	5555	1
139	10	7777	1
139	11	6666	1
140	1	2222	1
140	2	1001	1
140	3	4004	1
140	4	3003	1
140	5	2002	1
140	6	4444	3
140	7	1111	1
140	8	3333	3
140	9	5555	1
140	10	7777	1
140	11	6666	1
141	1	2222	3
141	2	3003	2
141	3	4004	5
141	4	2002	1
141	5	1001	1
141	6	4444	3
141	7	1111	1
141	8	3333	3
141	9	5555	1
141	10	7777	1
141	11	8888	5
142	1	2222	1
142	2	6666	1
142	3	3003	1
142	4	2002	1
142	5	1001	1
142	6	4004	3
142	7	1111	1
142	8	3333	3
142	9	5555	1
142	10	7777	1
142	11	4444	5
146	1	7777	1
146	2	1111	1
146	3	1001	1
146	4	3003	1
146	5	2002	1
146	6	4004	3
146	7	2222	1
146	8	3333	3
146	9	5555	4
146	10	4444	1
146	11	6666	5
143	1	2222	1
143	2	2002	1
143	3	5555	1
143	4	3003	1
143	5	1001	1
143	6	4004	3
143	7	1111	1
143	8	3333	3
143	9	4444	1
143	10	7777	1
143	11	6666	5
144	1	4444	1
144	2	2002	2
144	3	6666	1
144	4	3003	1
144	5	1001	1
144	6	4004	3
144	7	1111	1
144	8	3333	3
144	9	5555	1
144	10	7777	1
144	11	8888	5
145	1	6666	1
145	2	8888	4
145	3	3003	1
145	4	1001	1
145	5	4004	3
145	6	1111	1
145	7	3333	3
145	8	5555	1
145	9	7777	1
145	10	2222	5
147	1	6666	1
147	2	8888	4
148	1	3003	1
148	2	1001	1
149	1	4004	3
149	2	1111	1
150	1	3333	3
150	2	5555	1
150	3	7777	1
151	1	2222	5
151	2	8888	4
152	1	3003	1
153	1	1001	1
153	2	4004	3
153	3	1111	1
154	1	3333	3
154	2	5555	1
155	1	7777	1
155	2	2222	5
155	3	8888	4
156	1	3003	1
156	2	1001	1
156	3	4004	3
157	1	1111	1
158	1	3333	3
158	2	5555	1
158	3	7777	1
159	1	2222	5
159	2	8888	4
159	3	3003	1
159	4	1001	1
160	1	4004	3
161	1	1111	1
162	1	3333	3
162	2	5555	1
162	3	7777	1
163	1	2222	5
164	1	8888	4
164	2	3003	1
165	1	1001	1
165	2	4004	3
166	1	1111	1
166	2	3333	3
166	3	5555	1
167	1	7777	1
168	1	2222	5
169	1	2222	5
169	2	3333	5
170	1	2222	5
171	1	2222	8
172	1	2222	9
173	1	2222	1
173	2	4444	2
173	3	6666	2
173	4	8888	1
173	5	1111	1
173	6	1001	1
173	7	2002	1
173	8	3003	1
173	9	4004	1
173	10	5555	1
174	1	1111	10
174	2	3333	1
174	3	5555	1
174	4	7777	1
174	5	2222	1
174	6	4444	1
174	7	6666	1
174	8	8888	1
174	9	1001	1
174	10	3003	1
175	1	5555	1
175	2	7777	1
175	3	2222	1
175	4	4444	1
175	5	6666	1
175	6	1111	1
175	7	3333	1
175	8	1001	1
175	9	2002	1
175	10	3003	1
176	1	2222	1
176	2	1111	1
176	3	3333	1
176	4	5555	1
176	5	7777	1
176	6	4444	1
176	7	6666	1
176	8	8888	1
176	9	1001	1
176	10	2002	1
176	11	3003	1
176	12	4004	1
177	1	2222	1
177	2	2002	1
177	3	1001	1
177	4	1111	1
177	5	3333	1
177	6	5555	1
177	7	7777	1
177	8	4444	1
177	9	6666	1
177	10	8888	1
177	11	3003	1
177	12	4004	1
178	1	2222	1
178	2	2002	1
178	3	1001	1
178	4	3003	1
178	5	4004	1
178	6	4444	1
178	7	6666	1
178	8	8888	1
178	9	1111	1
178	10	3333	1
179	1	2222	1
179	2	8888	3
179	3	4444	3
179	4	6666	3
179	5	2002	3
179	6	4004	3
179	7	1111	3
179	8	3333	3
179	9	5555	3
179	10	7777	3
179	11	1001	3
180	1	2222	1
180	2	8888	1
180	3	4004	1
180	4	3003	1
180	5	1001	1
180	6	2002	3
180	7	1111	1
180	8	3333	3
180	9	5555	1
180	10	7777	1
180	11	6666	1
181	1	2222	1
181	2	1001	1
181	3	4004	1
181	4	3003	1
181	5	2002	1
181	6	4444	3
181	7	1111	1
181	8	3333	3
181	9	5555	1
181	10	7777	1
181	11	6666	1
182	1	2222	3
182	2	3003	2
182	3	4004	5
182	4	2002	1
182	5	1001	1
182	6	4444	3
182	7	1111	1
182	8	3333	3
182	9	5555	1
182	10	7777	1
182	11	8888	5
183	1	2222	1
183	2	6666	1
183	3	3003	1
183	4	2002	1
183	5	1001	1
183	6	4004	3
183	7	1111	1
183	8	3333	3
183	9	5555	1
183	10	7777	1
183	11	4444	5
184	1	7777	1
184	2	1111	1
184	3	1001	1
184	4	3003	1
184	5	2002	1
184	6	4004	3
184	7	2222	1
184	8	3333	3
184	9	5555	4
184	10	4444	1
184	11	6666	5
185	1	2222	1
185	2	2002	1
185	3	5555	1
185	4	3003	1
185	5	1001	1
185	6	4004	3
185	7	1111	1
185	8	3333	3
185	9	4444	1
185	10	7777	1
185	11	6666	5
186	1	4444	1
186	2	2002	2
186	3	6666	1
186	4	3003	1
186	5	1001	1
186	6	4004	3
196	7	1111	1
186	8	3333	3
186	9	5555	1
186	10	7777	1
186	11	8888	5
187	1	6666	1
187	2	8888	4
187	3	3003	1
187	4	1001	1
187	5	4004	3
187	6	1111	1
187	7	3333	3
187	8	5555	1
187	9	7777	1
187	10	2222	5
188	1	8888	1
188	2	1111	1
188	3	1001	1
188	4	3003	1
188	5	2002	1
188	6	4004	3
188	7	2222	1
188	8	3333	3
188	9	5555	1
188	10	7777	1
188	11	4444	5
189	1	2222	1
189	2	2002	1
189	3	4004	1
189	4	3003	1
189	5	1001	1
189	6	4444	3
189	7	1111	1
189	8	3333	3
189	9	5555	1
189	10	7777	1
189	11	6666	5
190	1	1111	1
190	2	1001	1
190	3	3003	1
190	4	2002	1
190	5	4004	3
190	6	2222	1
190	7	3333	3
190	8	5555	1
190	9	7777	1
190	10	4444	5
191	1	2222	1
191	2	4444	1
191	3	6666	1
191	4	2002	1
191	5	3003	1
191	6	1001	1
191	7	4004	3
191	8	1111	1
191	9	3333	3
191	10	5555	1
192	1	2222	1
192	2	4444	1
192	3	6666	1
192	4	3003	1
192	5	1001	1
192	6	4004	3
192	7	1111	1
192	8	3333	3
192	9	5555	1
192	10	7777	1
192	11	2002	5
193	1	4444	1
193	2	4004	1
193	3	7777	1
193	4	5555	1
193	5	1111	1
193	6	2222	1
194	1	1111	1
194	2	2222	1
194	3	7777	1
194	4	3003	1
194	5	1001	1
194	6	4004	3
194	7	4444	1
194	8	3333	3
194	9	5555	1
194	10	6666	1
194	11	2002	5
195	1	1111	1
195	2	3333	1
195	3	5555	1
195	4	7777	1
195	5	2222	1
195	6	4444	1
195	7	6666	1
195	8	8888	1
195	9	1001	1
195	10	3003	1
196	1	6666	21
197	1	6666	21
198	1	6666	21
199	1	6666	21
200	1	2222	1
200	2	4444	2
201	1	6666	2
201	2	8888	1
202	1	1111	1
202	2	1001	1
203	1	2002	1
203	2	3003	1
204	1	4004	1
204	2	5555	1
205	1	1111	10
205	2	3333	1
206	1	5555	1
206	2	7777	1
207	1	2222	1
208	1	4444	1
209	1	6666	1
210	1	8888	1
211	1	1001	1
211	2	3003	1
212	1	5555	1
213	1	7777	1
213	2	2222	1
213	3	4444	1
214	1	6666	1
215	1	1111	1
215	2	3333	1
215	3	1001	1
215	4	2002	1
216	1	3003	1
216	2	2222	1
217	1	1111	1
217	2	3333	1
218	1	5555	1
219	1	7777	1
219	2	4444	1
219	3	6666	1
220	1	8888	1
221	1	1001	1
221	2	2002	1
222	1	3003	1
\.


--
-- Name: author_pkey; Type: CONSTRAINT; Schema: public; Owner: ; Tablespace: 
--

ALTER TABLE ONLY author
    ADD CONSTRAINT author_pkey PRIMARY KEY (authorid);


--
-- Name: book_author_pkey; Type: CONSTRAINT; Schema: public; Owner: ; Tablespace: 
--

ALTER TABLE ONLY book_author
    ADD CONSTRAINT book_author_pkey PRIMARY KEY (isbn, authorid);


--
-- Name: book_pkey; Type: CONSTRAINT; Schema: public; Owner: ; Tablespace: 
--

ALTER TABLE ONLY book
    ADD CONSTRAINT book_pkey PRIMARY KEY (isbn);


--
-- Name: cust_order_pkey; Type: CONSTRAINT; Schema: public; Owner: ; Tablespace: 
--

ALTER TABLE ONLY cust_order
    ADD CONSTRAINT cust_order_pkey PRIMARY KEY (orderid);


--
-- Name: customer_pkey; Type: CONSTRAINT; Schema: public; Owner: ; Tablespace: 
--

ALTER TABLE ONLY customer
    ADD CONSTRAINT customer_pkey PRIMARY KEY (customerid);


--
-- Name: order_detail_pkey; Type: CONSTRAINT; Schema: public; Owner: ; Tablespace: 
--

ALTER TABLE ONLY order_detail
    ADD CONSTRAINT order_detail_pkey PRIMARY KEY (orderid, item_no);


--
-- Name: authrefint; Type: FK CONSTRAINT; Schema: public; Owner: 
--

ALTER TABLE ONLY book_author
    ADD CONSTRAINT authrefint FOREIGN KEY (authorid) REFERENCES author(authorid) ON UPDATE CASCADE ON DELETE SET DEFAULT;


--
-- Name: bookrefint; Type: FK CONSTRAINT; Schema: public; Owner: 
--

ALTER TABLE ONLY order_detail
    ADD CONSTRAINT bookrefint FOREIGN KEY (isbn) REFERENCES book(isbn) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: bookrefint; Type: FK CONSTRAINT; Schema: public; Owner: 
--

ALTER TABLE ONLY book_author
    ADD CONSTRAINT bookrefint FOREIGN KEY (isbn) REFERENCES book(isbn) ON UPDATE CASCADE ON DELETE SET DEFAULT;


--
-- Name: cust_ri; Type: FK CONSTRAINT; Schema: public; Owner: 
--

ALTER TABLE ONLY cust_order
    ADD CONSTRAINT cust_ri FOREIGN KEY (customerid) REFERENCES customer(customerid);


--
-- Name: ordrefint; Type: FK CONSTRAINT; Schema: public; Owner: 
--

ALTER TABLE ONLY order_detail
    ADD CONSTRAINT ordrefint FOREIGN KEY (orderid) REFERENCES cust_order(orderid) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: public; Type: ACL; Schema: -; Owner: pgsql
--

REVOKE ALL ON SCHEMA public FROM PUBLIC;
REVOKE ALL ON SCHEMA public FROM pgsql;
GRANT ALL ON SCHEMA public TO pgsql;
GRANT ALL ON SCHEMA public TO PUBLIC;


--
-- PostgreSQL database dump complete
--

