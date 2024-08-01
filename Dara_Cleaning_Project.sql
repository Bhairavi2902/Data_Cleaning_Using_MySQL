--- Data Cleaning --

SELECT *
FROM layoffs;

-- Remove duplicates
-- value standardization
-- remove irrelevant column

CREATE TABLE layoffs_staging
LIKE layoffs;

SELECT *
FROM layoffs_staging;

INSERT layoffs_staging
SELECT * 
FROM layoffs;

SELECT *,
ROW_NUMBER() OVER(PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country,funds_raised_millions) AS row_num
FROM layoffs_staging;

CREATE TABLE `layoffs_staging2` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL,
  `ronw_num` int
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

SELECT *
FROM layoffs_staging2;

INSERT INTO layoffs_staging2
SELECT *,
ROW_NUMBER() OVER(PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country,funds_raised_millions) AS row_num
FROM layoffs_staging;

SELECT *
FROM layoffs_staging2;

SELECT *
FROM layoffs_staging2
WHERE ronw_num>1;

DELETE
FROM layoffs_staging2
WHERE ronw_num>1;

SELECT *
FROM layoffs_staging2;

-- STANDARDIZATION OF DATA

SELECT company, TRIM(company)
FROM layoffs_staging2;

UPDATE layoffs_staging
SET company=TRIM(company);

SELECT industry
FROM layoffs_staging2
ORDER BY industry;

SELECT industry
FROM layoffs_staging2
WHERE industry LIKE "crypto%";

UPDATE layoffs_staging2
SET industry="Crypto"
WHERE industry LIKE "crypto%";

SELECT industry
FROM layoffs_staging2
WHERE industry LIKE "crypto%";

SELECT DISTINCT industry
FROM layoffs_staging2;

SELECT DISTINCT country
FROM layoffs_staging2
ORDER BY 1;

SELECT country
FROM layoffs_staging2
WHERE country LIKE "United States%";

SELECT DISTINCT country,TRIM(TRAILING '.' FROM country)
FROM layoffs_staging2
ORDER BY 1;

UPDATE layoffs_staging2
SET country=TRIM(TRAILING '.' FROM country)
WHERE country LIKE "United States%";

SELECT DISTINCT country
FROM layoffs_staging2
ORDER BY 1;

SELECT `date`
FROM layoffs_staging2;

SELECT `date`, str_to_date(`date`,'%m/%d/%Y')
FROM layoffs_staging2;

UPDATE layoffs_staging2
SET `date`= str_to_date(`date`,'%m/%d/%Y');

SELECT `date`
FROM layoffs_staging2;

SELECT *
FROM layoffs_staging2;

ALTER TABLE layoffs_staging2
MODIFY COLUMN `date` DATE;

SELECT *
FROM layoffs_staging2;

SELECT company,industry
FROM layoffs_staging2
WHERE industry IS NULL OR industry='';

UPDATE layoffs_staging2
SET industry=NULL
WHERE industry='';

SELECT company,industry
FROM layoffs_staging2
where company='Airbnb';


SELECT T1.company, T1.industry,T2.industry
FROM layoffs_staging2 AS T1
JOIN layoffs_staging2 AS T2
ON T1.company=T2.company
WHERE T1.industry IS NULL AND T2.industry IS NOT NULL;

UPDATE layoffs_staging2 AS T1
JOIN layoffs_staging2 AS T2
ON T1.company=T2.company
SET T1.industry=T2.industry
WHERE T1.industry IS NULL AND T2.industry IS NOT NULL;

SELECT T1.company, T1.industry,T2.industry
FROM layoffs_staging2 AS T1
JOIN layoffs_staging2 AS T2
ON T1.company=T2.company
WHERE T1.industry IS NULL AND T2.industry IS NOT NULL;


SELECT *
FROM layoffs_staging2
WHERE total_laid_off IS NULL AND percentage_laid_off IS NULL;

DELETE FROM layoffs_staging2
WHERE total_laid_off IS NULL AND percentage_laid_off IS NULL;

SELECT *
FROM layoffs_staging2
WHERE total_laid_off IS NULL AND percentage_laid_off IS NULL;

ALTER TABLE layoffs_staging2
DROP column ronw_num;

SELECT *
FROM layoffs_staging2;