package org.springframework.samples.petclinic.system;

import io.micrometer.core.instrument.MeterRegistry;
import io.micrometer.core.instrument.Timer;
import org.springframework.boot.context.event.ApplicationReadyEvent;
import org.springframework.boot.context.event.ApplicationStartedEvent;
import org.springframework.context.ApplicationListener;
import org.springframework.stereotype.Component;

//@Component
public class ApplicationStartupTimer {

	private final Timer startupTimer;

	private long startTime;

	public ApplicationStartupTimer(MeterRegistry meterRegistry) {
		this.startupTimer = meterRegistry.timer("application.startup.time");
	}

//	@Component
	public static class StartupListener implements ApplicationListener<ApplicationStartedEvent> {

		private final ApplicationStartupTimer startupTimer;

		public StartupListener(ApplicationStartupTimer startupTimer) {
			this.startupTimer = startupTimer;
		}

		@Override
		public void onApplicationEvent(ApplicationStartedEvent event) {
			startupTimer.startTime = System.currentTimeMillis();
		}
	}

//	@Component
	public static class ReadyListener implements ApplicationListener<ApplicationReadyEvent> {

		private final ApplicationStartupTimer startupTimer;

		public ReadyListener(ApplicationStartupTimer startupTimer) {
			this.startupTimer = startupTimer;
		}

		@Override
		public void onApplicationEvent(ApplicationReadyEvent event) {
			long duration = System.currentTimeMillis() - startupTimer.startTime;
			startupTimer.startupTimer.record(duration, java.util.concurrent.TimeUnit.MILLISECONDS);
		}
	}
}
