use std::process::Command;

use log::info;

pub struct Profile {
    pub configuration_name: String,
    pub base_vm_name: String,
    pub base_image_snapshot: String,
    pub target_count: usize,
}

impl Profile {
    pub fn create_runner(&self, id: usize) {
        info!(
            "Creating runner {id} with base vm name {}",
            self.base_vm_name
        );
        Command::new("../create-runner.sh")
            .args([
                &id.to_string(),
                &self.base_vm_name,
                &self.base_image_snapshot,
                &self.configuration_name,
            ])
            .spawn()
            .unwrap()
            .wait()
            .unwrap();
    }

    pub fn destroy_runner(&self, id: usize) {
        info!(
            "Destroying runner {id} with base vm name {}",
            self.base_vm_name
        );
        Command::new("../destroy-runner.sh")
            .args([&self.base_vm_name, &id.to_string()])
            .spawn()
            .unwrap()
            .wait()
            .unwrap();
    }
}
