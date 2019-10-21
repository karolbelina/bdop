SELECT pseudo,
       SUBSTR(temp, 1, INSTR(temp, 'L') - 1)
       || '%'
       || SUBSTR(temp, INSTR(temp, 'L') + 1) AS "Po wymianie A na # oraz L na %"
  FROM (SELECT pseudo,
               SUBSTR(pseudo, 1, INSTR(pseudo, 'A') - 1)
               || '#'
               || SUBSTR(pseudo, INSTR(pseudo, 'A') + 1) AS temp
          FROM kocury
         WHERE pseudo LIKE '%A%')
 WHERE pseudo LIKE '%L%';
