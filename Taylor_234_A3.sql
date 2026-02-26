DROP TABLE IF EXISTS NurseNote;
DROP TABLE IF EXISTS NurseNoteVec;

-- Part (a): create NurseNote table and insert N1-N3
CREATE TABLE NurseNote (
	patient_id INT PRIMARY KEY,
	address TEXT NOT NULL,
	note_text TEXT NOT NULL,
	visit_date DATE NOT NULL
);

INSERT INTO NurseNote (patient_id, address, note_text, visit_date) VALUES
	(101, 'Cleveland, OH', 'child anxious after vaccination', '2025-02-12'),
	(102, 'Akron, OH', 'persistent cough no fever', '2025-03-18'),
	(103, 'Columbus, OH', 'vaccination follow-up mild fever', '2025-03-20');

SELECT * FROM NurseNote;

-- Part (b): create NurseNoteVec table and insert TF-IDF vectors computed in Q1
-- v1: vaccination; v2: anxious; v3: cough
CREATE TABLE NurseNoteVec(
	patient_id INT PRIMARY KEY REFERENCES NurseNote(patient_id),
	v1 DOUBLE PRECISION NOT NULL,
	v2 DOUBLE PRECISION NOT NULL,
	v3 DOUBLE PRECISION NOT NULL
);


INSERT INTO NurseNoteVec (patient_id, v1, v2, v3) VALUES
	(101, 0.1761, 0.4771, 0.0),
	(102, 0.0, 0.0, 0.4771),
	(103, 0.1761, 0.0, 0.0);

SELECT * FROM NurseNoteVec;


-- Part (c): cosine similarity between vquery = (idf(vaccination), idf(anxious), 0) and each note vector and returns the top 2 notes
WITH query_vec AS(
	SELECT
		CAST(0.1761 AS DOUBLE PRECISION) AS q1,
		CAST(0.4771 AS DOUBLE PRECISION) AS q2,
		CAST(0.0 AS DOUBLE PRECISION) AS q3
)
SELECT 
	n.patient_id,
	(n.v1*q.q1 + n.v2*q.q2 + n.v3*q.q3) /( sqrt(n.v1*n.v1 + n.v2*n.v2 + n.v3*n.v3) *sqrt(q.q1*q.q1 + q.q2*q.q2 + q.q3*q.q3))
	AS cosine_sim
FROM NurseNoteVec n, query_vec q
ORDER BY cosine_sim DESC
LIMIT 2;

-- Patient 101 to XML using SQL XML functions
SELECT
	XMLELEMENT(
		NAME patient,
		XMLATTRIBUTES(('p' || n.patient_id::text) AS id),
		XMLELEMENT(NAME address, n.address),
		XMLELEMENT(
			NAME visits,
			XMLELEMENT(
				NAME visit,
				XMLATTRIBUTES(to_char(n.visit_date, 'YYYY-MM-DD') AS date),
				XMLELEMENT(NAME note, n.note_text)
			)
		)
	) AS patient_xml
FROM NurseNote n
WHERE n.patient_id = 101;