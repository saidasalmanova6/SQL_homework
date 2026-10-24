/* =====================================================================
   Çətinlik:  [*]  orta     [**]  çətin     [***]  ən çətin
   Hər tapşırığın altında boş yer var — həllinizi ora yazın.
   ===================================================================== */


/* =====================================================================
   BÖLMƏ A: SƏTİR FUNKSİYALARI
   ===================================================================== */

-- A1 [*]
-- Hər işçi üçün iki sütun göstərin:
--   qisa_ad  -> adın ilk hərfi + nöqtə + boşluq + soyad   (məs: S. King)
--   email    -> email sütunu kiçik hərflə + '@company.az'
-- Nəticə soyada görə əlifba sırası ilə olsun.
SELECT SUBSTR(FIRST_NAME,1,1) || '. ' || LAST_NAME AS Qisa_ad,
Lower(Email)||'@company.az' AS email
FROM EMPLOYEES e 
ORDER BY e.LAST_NAME ASC 



-- A2 [*]
-- Soyadı 5 hərfdən uzun olan, amma adında 'a' hərfi (böyük və ya kiçik)
-- OLMAYAN işçiləri tapın.
SELECT First_Name,Last_name FROM EMPLOYEES e 
WHERE LENGTH(LAST_NAME)>5 AND Lower(FIRST_NAME ) NOT LIKE '%a%'


-- A3 [*]
-- Adı və soyadı eyni hərflə başlayan işçiləri tapın.
SELECT First_name,Last_name FROM EMPLOYEES e 
WHERE SUBSTR(FIRST_name,1,1)=SUBSTR(Last_name,1,1)



-- A4 [**]
-- Bütün işçilərin maaşı 7.5% artırılır. Göstərin:
--   ad, soyad, köhnə maaş,
--   yeni_maas  -> 2 rəqəmə qədər yuvarlaqlaşdırılmış
--   artim      -> artım məbləği, tam ədədə AŞAĞI yuvarlaqlaşdırılmış
-- Yalnız yeni maaşı 10000-dən çox olanlar görünsün.
-- İpucu: WHERE-də alias işləyirmi?
SELECT First_name,Last_name,Salary AS kohne_maas, 
ROUND( Salary*1.075,2) AS Yeni_maas,
FLOOR( Salary*0.075) AS artim 
FROM Employees
WHERE Salary * 1.075>10000




-- A5 [*]
-- employee_id-si TƏK olan və maaşı 1000-ə TAM bölünən işçiləri tapın.
SELECT First_name,Last_name,e.EMPLOYEE_ID,e.SALARY 
FROM EMPLOYEES e 
WHERE MOD(Employee_id,2)=1 AND MOD (Salary,1000)=0




-- A6 [**]
-- Hər işçinin şirkətdə nə qədər işlədiyini bu formatda göstərin:
--   '12 il 4 ay'
-- (tam illər + qalan tam aylar)
SELECT First_name,Last_name,
Floor(Months_between(Sysdate,Hire_date)/12) || ' il '|| Floor(MOD(Months_between(Sysdate,Hire_date),12)) || ' ay' AS tecrube
FROM EMPLOYEES e 




-- A7 [**]
-- Hər işçinin işə başlama tarixini bu formatda göstərin:
--   'Monday, 17 June 2003'
-- və yalnız HƏFTƏ SONU (şənbə və ya bazar) işə başlayanları göstərin.

SELECT first_name,Last_name,TO_CHAR(Hire_date,'Day,DD Month YYYY') FROM EMPLOYEES e 
WHERE Trim(TO_CHAR(Hire_date,'day')) IN ('saturday','sunday')


-- A8 [*]
-- Ayın SON 5 GÜNÜNDƏ işə qəbul olunan işçiləri tapın.
-- (ayın neçə gün olmasından asılı olmayaraq düzgün işləməlidir)
SELECT First_name,Last_name,Hire_date
FROM EMPLOYEES e 
WHERE e.HIRE_DATE>= Last_day(e.HIRE_DATE )-4



-- A9 [**]
-- Hər işçinin sınaq müddəti işə qəbuldan 6 ay sonra bitir.
-- Göstərin: ad, hire_date, sınaq müddətinin bitdiyi tarix,
-- və ondan SONRAKI ilk bazar ertəsi (işçinin rəsmi qəbul günü).
SELECT First_name,Last_name,Hire_date,
ADD_MONTHS(Hire_date,6) AS sinaq_bitis_tarixi,
NEXT_DAY(ADD_MONTHS(Hire_date,6),'MONDAY') AS resmi_qebul_gunu
FROM EMPLOYEES e 




-- A10 [**]
-- Hər işçi üçün göstərin:
--   illik_gelir -> 12 aylıq maaş + komissiya
--                  (komissiya = illik maaş * commission_pct,
--                   komissiyası olmayan üçün 0)
--   status      -> 'Komissiyalı' və ya 'Komissiyasız'
-- İllik gəlirə görə azalan sıra ilə.
SELECT First_name,Last_name,
(Salary*12)+ NVL(Salary*12*Commission_pct,0) AS illik_gelir,
CASE 
	WHEN Commission_pct IS NOT NULL THEN  'kommisiyali'
     ELSE 'Kommisiyasiz'
     END AS status
FROM EMPLOYEES e 
ORDER BY illik_gelir DESC 



-- A11 [**]
-- Hər işçinin adını və rəhbərini göstərin:
--   manager_id varsa onun özü, yoxdursa 'Rəhbər yoxdur' yazılsın.
-- İpucu: NVL(manager_id, 'Rəhbər yoxdur') niyə işləmir?
-- 1ci usul
SELECT first_name,last_name,
NVL(TO_CHAR(manager_id), 'Rəhbər yoxdur') AS rehber
FROM EMPLOYEES e 

--2ci usul
SELECT FIRST_NAME,LAST_NAME,
       CASE
           WHEN MANAGER_ID IS NOT NULL THEN TO_CHAR(MANAGER_ID)
           ELSE 'Rəhbər yoxdur'
       END AS rehber
FROM EMPLOYEES 




-- A12 [***]
-- Maaşa görə kateqoriya yaradın:
--   15000 və çox       -> 'Rəhbər'
--   10000 – 14999      -> 'Yüksək'
--   5000  – 9999       -> 'Orta'
--   5000-dən az        -> 'Aşağı'
-- Nəticə əvvəlcə kateqoriyaya görə (Rəhbər, Yüksək, Orta, Aşağı
-- ardıcıllığı ilə — ƏLİFBA SIRASI İLƏ YOX!), sonra kateqoriya
-- daxilində soyada görə sıralansın.
SELECT first_name,last_name,Salary,
CASE
	WHEN Salary >=15000 THEN 'Rehber'
	WHEN Salary>=10000 THEN 'Yuksek'
	WHEN Salary>=5000 THEN 'Orta'
	ELSE 'asagi'
	END AS maas_kateqoriyasi
FROM employees
ORDER BY 
CASE
	WHEN Salary>=15000 THEN 1
	WHEN Salary>=10000 THEN 2
	WHEN Salary>=5000 THEN 3
	ELSE 4
END,Last_name ASC



	






/* =====================================================================
   BÖLMƏ B: QRUP FUNKSİYALARI, GROUP BY, HAVING
   ===================================================================== */

-- B1 [*]
-- Hər vəzifə (job_id) üzrə göstərin:
--   işçi sayı, ən aşağı maaş, ən yüksək maaş,
--   orta maaş (2 rəqəmə qədər yuvarlaq),
--   ən yüksək və ən aşağı maaş arasındakı fərq.
-- Yalnız 3 və daha çox işçisi olan vəzifələr,
-- maaş fərqinə görə azalan sıra ilə.
SELECT job_id, count(employee_id) AS isci_sayi,max(salary) AS max_maas,min(salary) AS min_maas,
round(avg(salary),2) AS orta_maas,max(salary)-min(salary) AS maas_ferqi
FROM EMPLOYEES e
GROUP BY Job_id
HAVING count(employee_id)>=3
ORDER BY maas_ferqi DESC






-- B2 [**]
-- Hər şöbə üzrə komissiya ALAN və ALMAYAN işçilərin sayını
-- yan-yana iki sütunda göstərin.
-- Şöbəsi olmayan işçilər də ayrıca sətirdə, ən yuxarıda görünsün.
SELECT 
nvl(TO_CHAR(department_id),'sobesi olmayanlar') AS sobe_id,
count(CASE WHEN commission_pct IS NOT NULL THEN 1 end) AS kommisiya_alanlar,
count(CASE WHEN commission_pct IS NULL THEN 1 end) AS kommisiya_almayanlar
FROM EMPLOYEES e 
GROUP BY e.DEPARTMENT_ID 
ORDER BY
CASE WHEN e.DEPARTMENT_ID IS NULL THEN 0
ELSE 1 
END,
e.DEPARTMENT_ID 




-- B3 [*]
-- Hər il üzrə neçə işçinin işə qəbul olunduğunu göstərin.
-- Ən çox işçi qəbul olunan il ən yuxarıda olsun.
SELECT TO_CHAR(hire_date,'YYYY') AS il,
count(*) AS isci_sayi
FROM EMPLOYEES e 
GROUP BY 
TO_CHAR(hire_date,'YYYY')
ORDER BY isci_sayi Desc



-- B4 [**]
-- Həftənin hər günü üzrə neçə işçinin işə qəbul olunduğunu göstərin
-- (məs: Monday 15, Tuesday 22 ...). Ən çoxu yuxarıda.
SELECT TO_char(hire_date,'Day') AS heftenin_gunu,
COUNT(*) AS isci_sayi
FROM EMPLOYEES e 
GROUP BY 
TO_char(hire_date,'Day')
ORDER BY isci_sayi Desc





-- B5 [**]
-- Orta maaşı 8000-dən çox olan və ən azı 2 işçisi olan şöbələri tapın.
-- Şöbəsi olmayan işçiləri hesablamaya daxil etməyin.
-- Hansı şərt WHERE-ə, hansı HAVING-ə yazılmalıdır?
SELECT department_id,
ROUND(AVG(salary),2) AS orta_maas,
COUNT(*) AS isci_sayi
FROM EMPLOYEES e 
WHERE department_id IS NOT NULL 
GROUP BY department_id
HAVING Round(Avg(Salary),2)>8000 AND count(*)>=2




-- B6 [**]
-- Soyadın İLK HƏRFİNƏ görə qruplaşdırın: hər hərf üçün işçi sayı.
-- Yalnız 3 və daha çox işçisi olan hərfləri, əlifba sırası ilə göstərin.
SELECT SUBSTR(last_name,1,1) AS first_letter,count(*) AS isci_sayi
FROM EMPLOYEES e 
GROUP BY first_letter
HAVING count(*)>=3
ORDER BY FIRST_LETTER ASC



-- B7 [**]
-- Hər rəhbər (manager_id) üzrə tabeliyində olan işçilərin sayını
-- və onların ümumi maaşını göstərin.
-- Yalnız ən azı 5 tabeçisi olan rəhbərlər, tabeçi sayına görə azalan.
SELECT manager_id AS rehber,
count(*) AS isci_sayi,
sum(salary) AS umumi_maas
FROM EMPLOYEES e 
GROUP BY e.MANAGER_ID 
HAVING count(*)>=5
ORDER BY ISCI_SAYI DESC





-- B8 [***]
-- Aşağıdakı xəritəyə görə şöbələri qruplaşdırın (DECODE ilə):
--   10 -> 'Admin', 20 -> 'Marketing', 50 -> 'Anbar', 80 -> 'Satış',
--   qalan hamısı (NULL da daxil) -> 'Digər'
-- Hər qrup üçün işçi sayı və orta maaş (tam ədədə yuvarlaq).
SELECT 
DECODE( department_id,
10,'admin',
20,'marketing',
50,'anbar',
80,'satis',
'diger')AS qrup_adi,
count(*) AS isci_sayi,
round(avg(salary)) AS orta_maas
FROM EMPLOYEES e 
GROUP BY
DECODE( department_id,
10,'admin',
20,'marketing',
50,'anbar',
80,'satis',
'diger')
ORDER BY COUNT(*) DESC






-- B9 [***]
-- Hər şöbə üzrə bir sətirdə göstərin:
--   ümumi işçi sayı,
--   maaşı 10000-dən çox olan işçilərin sayı,
--   maaşı 5000-dən az olan işçilərin sayı.
-- İpucu: COUNT NULL-ları saymır. CASE ilə birləşdirin.
SELECT department_id,count(*) AS umumi_isci_sayi,
count(CASE WHEN salary>10000 THEN 1 END ) AS maas_10k_cox,
count(CASE WHEN salary<5000 THEN 1 END ) AS maas_5k_az
FROM EMPLOYEES e 
GROUP BY e.DEPARTMENT_ID






-- B10 [***]
-- job_id-lər 'IT_PROG', 'SA_REP', 'ST_CLERK' kimi yazılıb.
-- Alt xəttdən ƏVVƏLKİ hissəyə (IT, SA, ST, ...) görə qruplaşdırın:
-- hər qrup üçün işçi sayı və orta maaş (tam ədədə yuvarlaq).
-- Orta maaşa görə azalan sıra ilə.
SELECT SUBSTR(e.JOB_ID,1,(INSTR(e.JOB_ID ,'_')-1)) AS JOB,count(*) AS isci_sayi,round(avg(salary)) AS orta_maas
FROM EMPLOYEES e 
GROUP BY JOB
ORDER BY round(avg(salary)) DESC






-- B11 [***]
-- Hər il üzrə göstərin:
--   həmin ilin ilk qəbul tarixi, son qəbul tarixi,
--   həmin il qəbul olunanlar arasında ən yüksək maaş.
-- Yalnız 5-dən çox işçi qəbul olunan illər.
SELECT TO_CHAR(hire_date,'YYYY') AS il,
MAX(Hire_date) AS ilk_qebul_tarixi,
min(Hire_date) AS son_qebul_tarixi,
max(salary) AS en_yuksek_maas
FROM EMPLOYEES e 
GROUP BY
TO_CHAR(hire_date,'YYYY')
HAVING count(*)>5




/* =====================================================================
   BÖLMƏ C: XƏTANI TAP VƏ İZAH ET (kompüterə baxmadan cavab verin,
            sonra işlədib yoxlayın)
   ===================================================================== */

-- C1
-- Bu sorğu niyə xəta verir? İki fərqli yolla düzəldin.
SELECT department_id, first_name, AVG(salary)
FROM employees
GROUP BY department_id,first_name;
-- ya first name qaldirilir yada group by hissesine oda elave olunur group byda selectde ne verilibse
--o yazilmalidi yoxsa xeta verir yada bi funksiyanin icinde olmalidi 



-- C2
-- Bu sorğu niyə xəta verir? Düzəldin.
SELECT job_id, SUM(salary) AS cem
FROM employees
WHERE SUM(salary)> 20000
GROUP BY job_id;
-- where icerisinde sum funksiyasi vermek olmaz

SELECT job_id, SUM(salary) AS cem
FROM employees
GROUP BY job_id
HAVING sum(salary)>20000





-- C3
-- Bu sorğunun 5 sütunu bir-birindən niyə fərqlidir?
-- Əvvəlcə təxmin edin, sonra işlədib yoxlayın.
   SELECT COUNT(*),
          COUNT(commission_pct),
          COUNT(DISTINCT commission_pct),
          AVG(commission_pct),
          AVG(NVL(commission_pct, 0))
   FROM employees;
--1ci umumi isci say 2ci kommisiyalarin sayi 3cu unikal kommisiyalar;n sayi 4cu kommisiyalarin orta hesabi
-- 5ci null olanlari 0 sayib orta kommisiyani ele tapr nullar saya daxil olaraq



-- C4
-- Bu sorğu xəta vermir, amma məntiqi səhvi var. Nədir?
SELECT first_name, salary,
CASE WHEN salary < 10000 THEN 'Orta'
WHEN salary < 5000  THEN 'Aşağı'
ELSE 'Yüksək'
END AS kateqoriya
FROM employees;
-- hem 10000den kicik hem 5000den kicik verdiyi ucun 5000den kiciklerde  orta olaraq gorunecek
--cunki case yuxaridan asagiya dogru oxudugu ucun ilk dogru olani qebul edib asagiya kecmir


