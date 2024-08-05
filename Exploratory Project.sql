-- Exploratory Data Analysis

SELECT *
FROM layoffs_staging2;

SELECT MAX(total_laid_off), MAX(percentage_laid_off)
FROM layoffs_staging2;

SELECT *
FROM layoffs_staging2
WHERE percentage_laid_off=1
ORDER BY total_laid_off DESC;

SELECT company, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY company
ORDER BY company;

SELECT MIN(`date`), MAX(`Date`)
FROM layoffs_staging2;

SELECT industry, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY industry
ORDER BY 2 DESC;

SELECT country,SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY country
ORDER BY 2 DESC;

SELECT stage,SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY stage
ORDER BY 2 DESC;

SELECT YEAR(`date`), SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY YEAR(`date`);

SELECT `date`, total_laid_off
FROM layoffs_staging2;

SELECT SUBSTRING(`date`,1,7) AS `MONTH`, total_laid_off
FROM layoffs_staging2
WHERE `date` IS NOT NULL
ORDER BY 1 ASC;

WITH ROLLING_SUM AS
(
SELECT SUBSTRING(`date`,1,7) AS `MONTH`, SUM(total_laid_off) AS total
FROM layoffs_staging2
WHERE `date` IS NOT NULL
GROUP BY SUBSTRING(`date`,1,7)
ORDER BY 1 ASC
)
SELECT `MONTH`,total,SUM(total) OVER(ORDER BY `MONTH`) AS Rolling_SUM
FROM ROLLING_SUM;

WITH Company_laid_off AS
(
SELECT company,YEAR(`date`) AS `Year`, SUM(total_laid_off) AS Total
FROM layoffs_staging2
WHERE YEAR(`date`) IS NOT NULL 
GROUP BY company,YEAR(`date`)
ORDER BY 2 ASC
), 
LAYOFF_RANK AS
(
SELECT company,`Year`,Total,
DENSE_RANK() OVER(PARTITION BY `YEAR` ORDER BY Total DESC) AS RANK_NO
FROM Company_laid_off
)
SELECT company, `Year`,Total,RANK_NO
FROM LAYOFF_RANK
WHERE RANK_NO<=5;
