package org.springframework.samples.petclinic.system;

import org.crac.CheckpointException;
import org.springframework.boot.context.event.ApplicationFailedEvent;
import org.springframework.context.ApplicationListener;
import org.springframework.stereotype.Component;

@Component
public class CheckpointFailureListener implements ApplicationListener<ApplicationFailedEvent> {

	@Override
	public void onApplicationEvent(ApplicationFailedEvent event) {
		Throwable exception = event.getException();
		if (exception != null) {
			if (exception.getCause() instanceof CheckpointException) {
				System.err.println("CRaC checkpoint creation failed. Terminating application.");
				System.exit(0);
			}
		}
	}

}
