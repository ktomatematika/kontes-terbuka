SELECT user_contest_id, COUNT(*) FROM short_submissions
WHERE user_contest_id IN (
	SELECT id FROM user_contests
	where contest_id = 5)
AND answer = (
	SELECT answer FROM short_problems
	WHERE id = short_submissions.short_problem_id)
GROUP BY user_contest_id
;
