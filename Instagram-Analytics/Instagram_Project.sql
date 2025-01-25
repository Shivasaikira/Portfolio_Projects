use ig_clone;

-- 1. Identify the five oldest users on Instagram 
select username,created_at
from users
order by created_at 
limit 5;

-- 2. Identify users who have never posted a single photo on Instagram 
select id,username
from users 
where id not in(
      select distinct user_id
      from photos
      where image_url is not null
      );

             
 -- 3.  Determine the winner of the contest and provide their details to the team        
	
    SELECT 
    username, photos.id, photos.image_url, COUNT(*) AS num_likes
FROM
    photos
        INNER JOIN
    likes ON likes.photo_id = photos.id
        INNER JOIN
    users ON photos.user_id = users.id
GROUP BY photos.id
ORDER BY num_likes DESC
LIMIT 1;


-- 4. Identify and suggest the top five most commonly used hashtags 

SELECT 
    tag_name, COUNT(tag_name) AS total
FROM
    tags
        JOIN
    photo_tags ON tags.id = photo_tags.tag_id
GROUP BY tags.id
ORDER BY total DESC
LIMIT 5;
       
       
       ## Investor Metric department answers:
 -- 1. Calculate the average number of posts per user on Instagram. Also, provide 
 -- the total number of photos on Instagram divided by the total number of users.

SELECT 
    (SELECT 
            COUNT(id)
        FROM
            photos) / (SELECT 
            COUNT(DISTINCT user_id)
        FROM
            photos) AS Average_posts_per_User,
    (SELECT 
            COUNT(id)
        FROM
            photos) / (SELECT 
            COUNT(id)
        FROM
            users) AS Ratio_of_Total_Posts_to_Total_Users;  
            
   -- 2.   Identify users (potential bots) who have liked every single photo on the site, 
   -- as this is not typically possible for a normal user       
        
          SELECT id,
       username
FROM   users
WHERE  id IN (SELECT user_id
              FROM   likes
              GROUP  BY user_id
              HAVING Count(user_id) = (SELECT Count(id)
                                       FROM   photos));   
        
        
