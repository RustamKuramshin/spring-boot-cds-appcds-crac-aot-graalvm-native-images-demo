package org.springframework.samples.petclinic;

import io.pyroscope.http.Format;
import io.pyroscope.javaagent.EventType;
import io.pyroscope.javaagent.PyroscopeAgent;
import io.pyroscope.javaagent.config.Config;
import jakarta.annotation.PostConstruct;
import org.springframework.core.env.Environment;
import org.springframework.stereotype.Component;

import java.time.Duration;

@Component
public class PyroscopeConfig {

	private final Environment environment;

	public PyroscopeConfig(Environment environment) {
		this.environment = environment;
	}

	@PostConstruct
	public void init() {

		String applicationName = getEnvOrProperty("PYROSCOPE_APPLICATION_NAME", "petclinic");
		String serverAddress = getEnvOrProperty("PYROSCOPE_SERVER_ADDRESS", "http://pyroscope:4040");

		PyroscopeAgent.start(new Config.Builder().setApplicationName(applicationName)
			.setProfilingEvent(EventType.ITIMER)
			.setFormat(Format.JFR)
			.setServerAddress(serverAddress)
			.setProfilingInterval(Duration.ofMillis(10))
			.setProfilingAlloc("512k")
			.setProfilingLock("10ms")
			.build());
	}

	private String getEnvOrProperty(String envVar, String defaultValue) {
		return environment.getProperty(envVar, System.getenv().getOrDefault(envVar, defaultValue));
	}

}
