package com.go.ski.payment.core.controller;

import java.util.List;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.go.ski.payment.core.service.PayService;
import com.go.ski.payment.support.dto.request.ApprovePaymentRequestDTO;
import com.go.ski.payment.support.dto.request.KakaopayApproveRequestDTO;
import com.go.ski.payment.support.dto.request.KakaopayCancelRequestDTO;
import com.go.ski.payment.support.dto.request.ReserveLessonPaymentRequestDTO;
import com.go.ski.payment.support.dto.response.KakaopayApproveResponseDTO;
import com.go.ski.payment.support.dto.response.KakaopayCancelResponseDTO;
import com.go.ski.payment.support.dto.request.KakaopayPrepareRequestDTO;
import com.go.ski.payment.support.dto.response.KakaopayPrepareResponseDTO;
import com.go.ski.payment.core.service.KakaoPayService;
import com.go.ski.payment.support.dto.response.OwnerPaymentHistoryResponseDTO;
import com.go.ski.payment.support.dto.response.UserPaymentHistoryResponseDTO;
import com.go.ski.payment.support.dto.response.WithdrawalResponseDTO;

import jakarta.servlet.http.HttpServletRequest;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@RestController
@RequiredArgsConstructor
@RequestMapping("/api/v1/payment")
public class PaymentController {

	private final PayService payService;
	private final KakaoPayService kakaoPayService;

	//결제 준비
	@PostMapping("/charge")
	public ResponseEntity<KakaopayPrepareResponseDTO> preparePayment(@RequestBody KakaopayPrepareRequestDTO request) {
		KakaopayPrepareResponseDTO response = kakaoPayService.getPrepareResponse(request);
		log.info("value : {}", response);
		return ResponseEntity.ok().body(response);
	}
	//결제 승인
	@PostMapping("/approve")
	public ResponseEntity<KakaopayApproveResponseDTO> approvePayment(@RequestBody KakaopayApproveRequestDTO request) {
		KakaopayApproveResponseDTO response = kakaoPayService.getApproveResponse(request);
		return ResponseEntity.ok().body(response);
	}

	//결제 취소
	@PostMapping("/cancel")
	public ResponseEntity<KakaopayCancelResponseDTO> cancelPayment(@RequestBody KakaopayCancelRequestDTO request) {
		KakaopayCancelResponseDTO response = kakaoPayService.getCancelResponse(request);
		return ResponseEntity.ok().body(response);
	}
	//강습 예약 결제 API -> 요청 uri 나중에 페이 연동 많아지면 domain 추가

	//결제의 단계가 준비랑, 승인임
	@PostMapping("/reserve/prepare")
	public ResponseEntity<KakaopayPrepareResponseDTO> preparePayment(
		HttpServletRequest httpServletRequest,
		@RequestBody ReserveLessonPaymentRequestDTO request) {

		KakaopayPrepareResponseDTO response = payService.getPrepareResponse(httpServletRequest, request);
		return ResponseEntity.ok().body(response);
	}
	@PostMapping("/reserve/approve")
	public ResponseEntity<KakaopayApproveResponseDTO> ApprovePayment(
		HttpServletRequest httpServletRequest,
		@RequestBody ApprovePaymentRequestDTO request) {

		KakaopayApproveResponseDTO response = payService.getApproveResponse(httpServletRequest, request);
		return ResponseEntity.ok().body(response);
	}

	@GetMapping("/history")
	public ResponseEntity<List<UserPaymentHistoryResponseDTO>> getUserPaymentHistory(HttpServletRequest httpServletRequest) {
		List<UserPaymentHistoryResponseDTO> response = payService.getUserPaymentHistories(httpServletRequest);
		return ResponseEntity.ok().body(response);
	}

	@GetMapping("/history/head")
	public ResponseEntity<List<OwnerPaymentHistoryResponseDTO>> getOwnerPaymentHistory(HttpServletRequest httpServletRequest) {
		List<OwnerPaymentHistoryResponseDTO> response = payService.getOwnerPaymentHistories(httpServletRequest);
		return ResponseEntity.ok().body(response);
	}

	@GetMapping("/history/{team_id}")
	public ResponseEntity<List<OwnerPaymentHistoryResponseDTO>> getTeamPaymentHistory(HttpServletRequest httpServletRequest
		, @PathVariable(value = "team_id") Integer teamId) {
		List<OwnerPaymentHistoryResponseDTO> response = payService.getTeamPaymentHistories(httpServletRequest, teamId);
		return ResponseEntity.ok().body(response);
	}

	@GetMapping("/withdrawal")
	public ResponseEntity<List<WithdrawalResponseDTO>> getWithdrawalList(HttpServletRequest httpServletRequest) {
		List<WithdrawalResponseDTO> response = payService.getWithdrawalList(httpServletRequest);
		return ResponseEntity.ok().body(response);
	}

	@GetMapping("/balance")
	public ResponseEntity<Integer> getBalance(HttpServletRequest httpServletRequest) {
		Integer response = payService.getBalance(httpServletRequest);
		return ResponseEntity.ok().body(response);
	}
	//pgTokenTest
	//pg 토큰 받아와야해서 이렇게 만들어봤음
	// @GetMapping("/getPg/{pg_token}")
	// public String returnPg(@PathVariable(value = "pg_token") String pgToken) {
	// 	log.info(pgToken);
	// 	return pgToken;
	// }

}
