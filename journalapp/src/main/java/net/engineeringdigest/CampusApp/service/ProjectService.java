package net.engineeringdigest.CampusApp.service;

import net.engineeringdigest.CampusApp.entity.Project;
import net.engineeringdigest.CampusApp.repository.ProjectRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import java.util.ArrayList;
import java.util.List;

@Component
public class ProjectService {

    @Autowired
    private ProjectRepository projectRepository;



    public List<Project> getAll() {
        return projectRepository.findAll();
    }}








