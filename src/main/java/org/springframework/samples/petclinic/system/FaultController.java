package org.springframework.samples.petclinic.system;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.util.ArrayList;
import java.util.List;

@RestController
@RequestMapping("/fault")
public class FaultController {

	@GetMapping("/cpu")
	public String stressCpu(@RequestParam(defaultValue = "100000") int iterations) {
		long startTime = System.nanoTime();
		long result = fibonacciIterative(iterations);
		long elapsedTime = System.nanoTime() - startTime;

		return "CPU стресс-тест завершён! Fibonacci(" + iterations + ") = " + result + ". Время выполнения: "
				+ elapsedTime / 1_000_000 + " мс.";
	}

	@GetMapping("/memory")
	public String stressMemory(@RequestParam(defaultValue = "500") int size) {
		List<int[]> memoryEater = new ArrayList<>();
		for (int i = 0; i < size; i++) {
			memoryEater.add(new int[10_000_000]);
		}
		return "Память загружена! Создано " + size + " больших объектов.";
	}

	private long fibonacciIterative(int n) {
		if (n <= 1)
			return n;

		long prev = 0, curr = 1;
		for (int i = 2; i <= n; i++) {
			long temp = prev + curr;
			prev = curr;
			curr = temp;
		}
		return curr;
	}

}
