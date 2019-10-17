SELECT pseudo,
       SUBSTR(temp, 1, INSTR(temp, 'L') - 1)
       || REPLACE(SUBSTR(temp, INSTR(temp, 'L'), 1), 'L', '%')
       || SUBSTR(temp, INSTR(temp, 'L') + 1)
  FROM (SELECT pseudo,
               SUBSTR(pseudo, 1, INSTR(pseudo, 'A') - 1)
               || REPLACE(SUBSTR(pseudo, INSTR(pseudo, 'A'), 1), 'A', '#')
               || SUBSTR(pseudo, INSTR(pseudo, 'A') + 1) AS temp
          FROM kocury
         WHERE pseudo LIKE '%A%')
 WHERE pseudo LIKE '%L%';
