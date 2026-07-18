-- Optional integrity migration. Apply after database/001_spectrem_director.sql on MySQL 8+/MariaDB with JSON support.
ALTER TABLE spectrem_director_scenes ADD CONSTRAINT fk_sd_scenes_project FOREIGN KEY (project_id) REFERENCES spectrem_director_projects(id) ON DELETE CASCADE;
ALTER TABLE spectrem_director_entities ADD CONSTRAINT fk_sd_entities_project FOREIGN KEY (project_id) REFERENCES spectrem_director_projects(id) ON DELETE CASCADE;
ALTER TABLE spectrem_director_actors ADD CONSTRAINT fk_sd_actors_project FOREIGN KEY (project_id) REFERENCES spectrem_director_projects(id) ON DELETE CASCADE;
ALTER TABLE spectrem_director_props ADD CONSTRAINT fk_sd_props_project FOREIGN KEY (project_id) REFERENCES spectrem_director_projects(id) ON DELETE CASCADE;
ALTER TABLE spectrem_director_vehicles ADD CONSTRAINT fk_sd_vehicles_project FOREIGN KEY (project_id) REFERENCES spectrem_director_projects(id) ON DELETE CASCADE;
