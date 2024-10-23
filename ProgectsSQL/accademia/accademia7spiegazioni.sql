--1. Media e deviazione standard degli stipendi per ogni categoria di strutturati sql

SELECT p.posizione, AVG(p.stipendio), STDDEV(p.stipendio)
FROM Persona p
GROUP BY p.posizione;
Spiegazione:

--SELECT: Qui selezioni tre cose:
--p.posizione: La posizione della persona (per esempio: Ricercatore, Professore Associato, ecc.).
--AVG(p.stipendio): La media (AVG) degli stipendi per ogni posizione.
--STDDEV(p.stipendio): La deviazione standard degli stipendi per ogni posizione, che misura quanto gli stipendi variano rispetto alla media.
--FROM Persona p: Qui stai prelevando i dati dalla tabella Persona, e p è un alias che rappresenta ogni record della tabella. Significa che invece 
--di scrivere sempre Persona, usi semplicemente p.
--GROUP BY p.posizione: Questo è un passaggio fondamentale. Raggruppa i dati in base alla posizione (per esempio: "Ricercatore", "Professore Associato", 
--ecc.). La GROUP BY è usata perché vuoi calcolare la media e la deviazione standard per ogni gruppo di posizioni. Quindi, avrai una riga per ogni diversa posizione.

--Cosa ottieni alla fine?
--Una tabella con tre colonne:
--posizione: La posizione della persona (es: Ricercatore, Professore Associato, ecc.).
--AVG(p.stipendio): La media degli stipendi per quella posizione.
--STDDEV(p.stipendio): La deviazione standard degli stipendi per quella posizione.



--2. Ricercatori con stipendio superiore alla media della loro categoria

WITH M AS (
    SELECT avg(p.stipendio) as media_stip
    FROM Persona p
    WHERE p.posizione = 'Ricercatore'
)
SELECT p.*
FROM Persona p, M m
WHERE p.posizione = 'Ricercatore'
    AND p.stipendio > m.media_stip;

--Spiegazione:

--WITH M AS (...): Qui stai creando una sottoquery o CTE (Common Table Expression) chiamata M. La usi per calcolare la media 
--degli stipendi dei ricercatori, e poi la utilizzi nella query principale.

--Dettaglio della sottoquery M:

--SELECT avg(p.stipendio) as media_stip: Calcoli la media (AVG) degli stipendi di tutti i ricercatori.
--FROM Persona p: Prendi i dati dalla tabella Persona.
--WHERE p.posizione = 'Ricercatore': Consideri solo le persone che hanno la posizione di Ricercatore.
--Alla fine di questa sottoquery, M contiene una colonna chiamata media_stip, che è la media degli stipendi dei ricercatori.

--Query principale:

--FROM Persona p, M m: Stai usando sia la tabella Persona che il risultato della sottoquery M (che ora è considerata come una piccola tabella).

--WHERE p.posizione = 'Ricercatore': Filtri solo i record delle persone che sono ricercatori.
--AND p.stipendio > m.media_stip: Qui confronti lo stipendio di ogni ricercatore con la media degli stipendi dei ricercatori calcolata nella sottoquery. 
--Se lo stipendio della persona è maggiore della media, viene incluso nel risultato.

--Cosa ottieni alla fine?
--Ottieni una lista di ricercatori i cui stipendi sono superiori alla media degli stipendi dei ricercatori.


