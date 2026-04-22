package dev.siyoung.plantit.plantitbe;

import org.springframework.boot.SpringApplication;

public class TestPlantItBeApplication {

    public static void main(String[] args) {
        SpringApplication.from(PlantItBeApplication::main).with(TestcontainersConfiguration.class).run(args);
    }

}
