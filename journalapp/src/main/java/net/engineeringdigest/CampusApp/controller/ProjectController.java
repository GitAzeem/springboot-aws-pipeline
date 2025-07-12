package net.engineeringdigest.CampusApp.controller;

import net.engineeringdigest.CampusApp.entity.Project;
import net.engineeringdigest.CampusApp.service.ProjectService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/project")
public class ProjectController {

    // Service dependencies
    @Autowired
    private ProjectService projectService;


    @GetMapping("/all")
    public List<Project> getallproject(){
        return projectService.getAll();
    }
}

