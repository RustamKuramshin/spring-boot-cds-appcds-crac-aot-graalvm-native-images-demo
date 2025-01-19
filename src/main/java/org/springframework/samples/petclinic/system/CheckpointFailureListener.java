package org.springframework.samples.petclinic.system;

import lombok.extern.slf4j.Slf4j;
import org.crac.CheckpointException;
import org.springframework.boot.context.event.ApplicationFailedEvent;
import org.springframework.context.ApplicationListener;
import org.springframework.stereotype.Component;

@Slf4j
@Component
public class CheckpointFailureListener implements ApplicationListener<ApplicationFailedEvent> {

	@Override
	public void onApplicationEvent(ApplicationFailedEvent event) {
		Throwable exception = event.getException();
		if (exception != null) {
			if (exception.getCause() instanceof CheckpointException cpe) {
				log.error("CRaC checkpoint creation failed. Terminating application.", cpe);
				System.exit(0);
			}
		}
	}

}
