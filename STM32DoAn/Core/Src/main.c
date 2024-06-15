/* USER CODE BEGIN Header */
/**
  ******************************************************************************
  * @file           : main.c
  * @brief          : Main program body
  ******************************************************************************
  * @attention
  *
  * Copyright (c) 2024 STMicroelectronics.
  * All rights reserved.
  *
  * This software is licensed under terms that can be found in the LICENSE file
  * in the root directory of this software component.
  * If no LICENSE file comes with this software, it is provided AS-IS.
  *
  ******************************************************************************
  */
/* USER CODE END Header */
/* Includes ------------------------------------------------------------------*/
#include "main.h"

/* Private includes ----------------------------------------------------------*/
/* USER CODE BEGIN Includes */
#include "MFRC522.h"
//#include "i2c-lcd.h"
#include "liquidcrystal_i2c.h"
#include "string.h"
/* USER CODE END Includes */

/* Private typedef -----------------------------------------------------------*/
/* USER CODE BEGIN PTD */
uint8_t str[11];
uint8_t status;
uint8_t ChuoiNhan[11];
uint8_t CoNhan;
uint8_t temp[11];
uint8_t a = 0;
uint8_t size = 11;
uint8_t KyTuNhan;
uint8_t rxindex = 0;
uint8_t BienSoXe[11];
uint8_t TinHieuDieuKhien[11];
uint8_t TrangThaiCua = 0;
uint8_t State = 0;
uint8_t ChiSo = 0;
uint8_t temp1[11];
uint8_t ThoiGianCho[1] = "9";
uint8_t BoDem = 0;

//Tin hieu dieu khien
char MoCuaVao[] = "1";
char MoCuaRa[] = "2";
char ChuaDangKyTaiKhoan[] = "3";
char HetTien[] = "4";
char ChuaDangKyRFID[] = "5";
char ThemThanhCong[] = "6";
char LoiMang[] = "7";
char KetNoiWifi[] = "8";


/* USER CODE END PTD */

/* Private define ------------------------------------------------------------*/
/* USER CODE BEGIN PD */

/* USER CODE END PD */

/* Private macro -------------------------------------------------------------*/
/* USER CODE BEGIN PM */

/* USER CODE END PM */

/* Private variables ---------------------------------------------------------*/
I2C_HandleTypeDef hi2c2;

SPI_HandleTypeDef hspi1;

TIM_HandleTypeDef htim11;

UART_HandleTypeDef huart1;

/* USER CODE BEGIN PV */

/* USER CODE END PV */

/* Private function prototypes -----------------------------------------------*/
void SystemClock_Config(void);
static void MX_GPIO_Init(void);
static void MX_SPI1_Init(void);
static void MX_TIM11_Init(void);
static void MX_USART1_UART_Init(void);
static void MX_I2C2_Init(void);
/* USER CODE BEGIN PFP */

/* USER CODE END PFP */

/* Private user code ---------------------------------------------------------*/
/* USER CODE BEGIN 0 */
void HAL_UART_RxCpltCallback(UART_HandleTypeDef *huart)
{
  /* Prevent unused argument(s) compilation warning */
  UNUSED(huart);
  /* NOTE: This function should not be modified, when the callback is needed,
           the HAL_UART_RxCpltCallback could be implemented in the user file
   */
  /*if (huart->Instance == huart1.Instance)
  {
	  if (State == 0)
	  {
		  if (KyTuNhan == 'A')
			  State = 1;
	  }
	  else if (State == 1)
	  {
		  if (KyTuNhan == 'A')
			  State = 2;
		  else
			  State = 0;
	  }
	  else if (State == 3)
	  {
		  size = KyTuNhan;
		  State = 3;
	  }
	  else if (State == 3)
	  {
		  if (size > 1)
		  {
		  	  ChuoiNhan[rxindex] = KyTuNhan;
		  	  rxindex++;
		  	  size--;
		  }
		  else
		  {
		  	  ChuoiNhan[rxindex] = KyTuNhan;
		  	  rxindex = 0;
		  	  CoNhan = 0;
		  	  State = 0;
		  	  memcpy(temp, ChuoiNhan, sizeof(temp));
		  }
	  }
	  temp1[ChiSo] = KyTuNhan;
	  ChiSo++;
	  if (ChiSo == 10)
		  ChiSo = 0;
	  HAL_UART_Receive_IT(&huart1, &KyTuNhan, 1);
  }*/
  if (huart->Instance == huart1.Instance)
    {
  	  	  	  if (size > 1)
  	  	  	  {
  	  	  		  ChuoiNhan[rxindex] = KyTuNhan;
  	  	  		  rxindex++;
  	  	  		  size--;
    	  	  	  }
  	  	  	  else
  	  	  	  {
  	  	  		ChuoiNhan[rxindex] = KyTuNhan;
  	  	  		rxindex = 0;
  	  	  		CoNhan = 0;
  	  	  		size = 11;
  	  	  		memcpy(temp, ChuoiNhan, sizeof(temp));
  	  	  		//memcpy(ChuoiNhan, "\0", 11);
  	  	  	  }
  	  	HAL_UART_Receive_IT(&huart1, &KyTuNhan, 1);
    }
}
/* USER CODE END 0 */

/**
  * @brief  The application entry point.
  * @retval int
  */
int main(void)
{
  /* USER CODE BEGIN 1 */

  /* USER CODE END 1 */

  /* MCU Configuration--------------------------------------------------------*/

  /* Reset of all peripherals, Initializes the Flash interface and the Systick. */
  HAL_Init();

  /* USER CODE BEGIN Init */

  /* USER CODE END Init */

  /* Configure the system clock */
  SystemClock_Config();

  /* USER CODE BEGIN SysInit */

  /* USER CODE END SysInit */

  /* Initialize all configured peripherals */
  MX_GPIO_Init();
  MX_SPI1_Init();
  MX_TIM11_Init();
  MX_USART1_UART_Init();
  MX_I2C2_Init();
  /* USER CODE BEGIN 2 */
  HAL_GPIO_WritePin(RC522_Rst_GPIO_Port, RC522_Rst_Pin, GPIO_PIN_SET);
  MFRC522_Init();
  HAL_UART_Receive_IT(&huart1, &KyTuNhan, 1);
  HAL_I2C_Init(&hi2c2);
  HAL_TIM_PWM_Start(&htim11, TIM_CHANNEL_1);
  htim11.Instance->CCR1 = 100;
  //lcd_init();
  HD44780_Init(2);
  HD44780_Clear();
  HD44780_SetCursor(0, 0);
  HD44780_PrintStr("Dang ket noi...");
  HAL_Delay(10000);
  HD44780_Clear();
  HD44780_SetCursor(0, 0);
  HD44780_PrintStr("Cho the");
  /* USER CODE END 2 */

  /* Infinite loop */
  /* USER CODE BEGIN WHILE */
  while (1)
  {
	  if (!MFRC522_Request(PICC_REQIDL, str))
	  	  	  {
	  	  		  if (!MFRC522_Anticoll(str))
	  	  		  {
	  	  			//Gui Ma The qua UART
	  	  			HAL_UART_Transmit(&huart1, str, 5, 100);
	  	  			//Nhan Tin hieu dieu khien tu ESP32
	  	  			CoNhan = 1;
	  	  			while (CoNhan);
	  	  			memcpy(TinHieuDieuKhien, temp, 11);
	  	  			//Thuc hien hanh dong
	  	  			//Thuc hien ra vao
	  	  			if ((strcmp((char*)TinHieuDieuKhien, MoCuaVao) == 0) || (strcmp((char*)TinHieuDieuKhien, MoCuaRa) == 0))
	  	  			  	{
	  	  			  		//Nhan Bien so xe tu ESP32
	  	  					CoNhan = 1;
	  	  			  		while (CoNhan);
	  	  			  		memcpy(BienSoXe, temp, 11);
	  	  			  		//Thuc hien vao
	  	  			  		if (strcmp((char*)TinHieuDieuKhien, MoCuaVao) == 0)
	  	  			  		{
	  	  			  			//In ra man hinh
	  	  			  			HD44780_Clear();
	  	  			  			HD44780_PrintStr((char*) BienSoXe);
	  	  			  			HD44780_SetCursor(0, 1);
	  	  			  			HD44780_PrintStr("Chao mung!");
	  	  			  			//Mo Cua
	  	  			  			htim11.Instance->CCR1 = 50;

	  	  			  			HAL_Delay(5000);
	  	  			  			HD44780_Clear();
	  	  			  			HD44780_PrintStr("Cho the");
	  	  			  			//Dong Cua
	  	  			  			htim11.Instance->CCR1 = 100;
	  	  			  		}
	  	  			  		//Thuc hien ra
	  	  			  		else if (strcmp((char*)TinHieuDieuKhien, MoCuaRa) == 0)
	  	  			  		{
	  	  			  			//In ra man hinh
	  	  			  			HD44780_Clear();
	  	  			  			HD44780_PrintStr((char*) BienSoXe);
	  	  			  			HD44780_SetCursor(0, 1);
	  	  			  			HD44780_PrintStr("Tam biet!");
	  	  			  			//Mo Cua
	  	  			  			htim11.Instance->CCR1 = 50;

	  	  			  			HAL_Delay(5000);
	  	  			  			HD44780_Clear();
	  	  			  			HD44780_PrintStr("Cho the");
	  	  			  			//Dong Cua
	  	  			  			htim11.Instance->CCR1 = 100;
	  	  			  		}
	  	  			  	}
	  	  				//Thuc hien khi het tien
	  	  			  	else if (strcmp((char*)TinHieuDieuKhien, HetTien) == 0)
	  	  			  	{
	  	  			  		HD44780_Clear();
	  	  			  		HD44780_PrintStr("So du khong du");
	  	  			  		HD44780_SetCursor(0, 1);
	  	  			  		HD44780_PrintStr("Vui long dua tien mat!");
	  	  			  		HAL_Delay(1000);
	  	  			  		HD44780_Clear();
	  	  			  		HD44780_PrintStr("Thoi gian cho: ");
	  	  			  		HD44780_PrintStr((char*)ThoiGianCho);

	  	  			  		while (ThoiGianCho[0] > '0' && HAL_GPIO_ReadPin(Button_GPIO_Port, Button_Pin))
	  	  			  		{
	  	  			  			BoDem++;
	  	  			  			if (BoDem == 100)
	  	  			  			{
	  	  			  				ThoiGianCho[0]--;
	  	  			  				BoDem = 0;
	  	  			  				HD44780_Clear();
	  	  			  				HD44780_PrintStr("Thoi gian cho: ");
	  	  			  				HD44780_PrintStr((char*)ThoiGianCho);
	  	  			  			}
	  	  			  			HAL_Delay(10);
	  	  			  		}
	  	  			  		if (ThoiGianCho[0] > '0')
	  	  			  		{
	  	  			  			HAL_UART_Transmit(&huart1, (uint8_t*)"1", 1, 100);
	  	  			  			CoNhan = 1;
	  	  			  			while (CoNhan);
	  	  			  			memcpy(BienSoXe, temp, 11);
	  	  			  			HD44780_Clear();
	  	  			  			HD44780_PrintStr((char*) BienSoXe);
	  	  			  			HD44780_SetCursor(0, 1);
	  	  			  			HD44780_PrintStr("Chao mung!");
	  	  			  			//Mo Cua
	  	  			  			htim11.Instance->CCR1 = 50;

	  	  			  			HAL_Delay(5000);
	  	  			  			HD44780_Clear();
	  	  			  			HD44780_PrintStr("Cho the");
	  	  			  			//Dong Cua
	  	  			  			htim11.Instance->CCR1 = 100;
	  	  			  		}
	  	  			  		else
	  	  			  		{
	  	  			  			HAL_UART_Transmit(&huart1, (uint8_t*)"0", 1, 100);
	  	  			  			HAL_Delay(1000);
	  	  			  			HD44780_Clear();
	  	  			  			HD44780_PrintStr("Cho the");
	  	  			  		}
	  	  			  		BoDem = 0;
	  	  			  		ThoiGianCho[0] = '9';
	  	  			  	}
	  	  				//Thuc hien khi chua dang ky
	  	  			  	else if (strcmp((char*)TinHieuDieuKhien, ChuaDangKyRFID) == 0)
	  	  			  	{
	  	  			  		HD44780_Clear();
	  	  			  		HD44780_PrintStr((char*) "Chua dang ky the");
	  	  			  		HAL_Delay(3000);
	  	  			  		HD44780_Clear();
	  	  			  		HD44780_PrintStr("Cho the");
	  	  			  	}
	  	  				//Thuc hien khi them the thanh cong
	  	  			  	else if (strcmp((char*)TinHieuDieuKhien, ThemThanhCong) == 0)
	  	  			  	{
	  	  			  		HD44780_Clear();
	  	  			  		HD44780_PrintStr((char*) "Them thanh cong");
	  	  			  		HAL_Delay(3000);
	  	  			  		HD44780_Clear();
	  	  			  		HD44780_PrintStr("Cho the");
	  	  			  	}
	  	  				//THuc hien khi bi loi mang
	  	  			  	else if (strcmp((char*)TinHieuDieuKhien, LoiMang) == 0)
	  	  			  	{
	  	  			  		HD44780_Clear();
	  	  			  		HD44780_PrintStr((char*) "Loi mang!Thu lai");
	  	  			  		HAL_Delay(3000);
	  	  			  		HD44780_Clear();
	  	  			  		HD44780_PrintStr("Cho the");
	  	  			  	}
	  	  			  	else if (strcmp((char*)TinHieuDieuKhien, ChuaDangKyTaiKhoan) == 0)
	  	  			  	{
	  	  			  		HD44780_Clear();
	  	  			  		HD44780_PrintStr((char*) "Chua dang ky TK");
		  	  			  	HAL_Delay(3000);
	  	  			  		HD44780_Clear();
		  	  			  	HD44780_PrintStr("Cho the");
	  	  			  	}
	  	  			//CoNhan = 1;
	  	  			//while (CoNhan);
	  	  			//memcpy(BienSoXe, temp, 10);

	  	  			//lcd_send_string((char*)Test);
	  	  			//lcd_goto_XY(0, 1);
	  	  			//lcd_send_string("Chao mung");
	  	  			//lcd_clear_display();
	  	  		  }
	  	  	  }
    /* USER CODE END WHILE */

    /* USER CODE BEGIN 3 */
	  //Dieu khien bang nut bam
	  	if (!HAL_GPIO_ReadPin(Button_GPIO_Port, Button_Pin))
	  	{
	  		//Mo cua, dong cua
	  		if (TrangThaiCua == 0)
	  		{
	  			//Mo Cua
	  			htim11.Instance->CCR1 = 100;
	  			TrangThaiCua = 1;
	  		}
	  		else if (TrangThaiCua == 1)
	  		{
	  			//Dong Cua
	  			htim11.Instance->CCR1 = 50;
	  			TrangThaiCua = 0;
	  		}
	  		HAL_Delay(500);
	  	}
  }
  /* USER CODE END 3 */
}

/**
  * @brief System Clock Configuration
  * @retval None
  */
void SystemClock_Config(void)
{
  RCC_OscInitTypeDef RCC_OscInitStruct = {0};
  RCC_ClkInitTypeDef RCC_ClkInitStruct = {0};

  /** Configure the main internal regulator output voltage
  */
  __HAL_RCC_PWR_CLK_ENABLE();
  __HAL_PWR_VOLTAGESCALING_CONFIG(PWR_REGULATOR_VOLTAGE_SCALE1);

  /** Initializes the RCC Oscillators according to the specified parameters
  * in the RCC_OscInitTypeDef structure.
  */
  RCC_OscInitStruct.OscillatorType = RCC_OSCILLATORTYPE_HSI;
  RCC_OscInitStruct.HSIState = RCC_HSI_ON;
  RCC_OscInitStruct.HSICalibrationValue = RCC_HSICALIBRATION_DEFAULT;
  RCC_OscInitStruct.PLL.PLLState = RCC_PLL_ON;
  RCC_OscInitStruct.PLL.PLLSource = RCC_PLLSOURCE_HSI;
  RCC_OscInitStruct.PLL.PLLM = 8;
  RCC_OscInitStruct.PLL.PLLN = 100;
  RCC_OscInitStruct.PLL.PLLP = RCC_PLLP_DIV2;
  RCC_OscInitStruct.PLL.PLLQ = 4;
  if (HAL_RCC_OscConfig(&RCC_OscInitStruct) != HAL_OK)
  {
    Error_Handler();
  }

  /** Initializes the CPU, AHB and APB buses clocks
  */
  RCC_ClkInitStruct.ClockType = RCC_CLOCKTYPE_HCLK|RCC_CLOCKTYPE_SYSCLK
                              |RCC_CLOCKTYPE_PCLK1|RCC_CLOCKTYPE_PCLK2;
  RCC_ClkInitStruct.SYSCLKSource = RCC_SYSCLKSOURCE_PLLCLK;
  RCC_ClkInitStruct.AHBCLKDivider = RCC_SYSCLK_DIV1;
  RCC_ClkInitStruct.APB1CLKDivider = RCC_HCLK_DIV2;
  RCC_ClkInitStruct.APB2CLKDivider = RCC_HCLK_DIV1;

  if (HAL_RCC_ClockConfig(&RCC_ClkInitStruct, FLASH_LATENCY_3) != HAL_OK)
  {
    Error_Handler();
  }
}

/**
  * @brief I2C2 Initialization Function
  * @param None
  * @retval None
  */
static void MX_I2C2_Init(void)
{

  /* USER CODE BEGIN I2C2_Init 0 */

  /* USER CODE END I2C2_Init 0 */

  /* USER CODE BEGIN I2C2_Init 1 */

  /* USER CODE END I2C2_Init 1 */
  hi2c2.Instance = I2C2;
  hi2c2.Init.ClockSpeed = 100000;
  hi2c2.Init.DutyCycle = I2C_DUTYCYCLE_2;
  hi2c2.Init.OwnAddress1 = 0;
  hi2c2.Init.AddressingMode = I2C_ADDRESSINGMODE_7BIT;
  hi2c2.Init.DualAddressMode = I2C_DUALADDRESS_DISABLE;
  hi2c2.Init.OwnAddress2 = 0;
  hi2c2.Init.GeneralCallMode = I2C_GENERALCALL_DISABLE;
  hi2c2.Init.NoStretchMode = I2C_NOSTRETCH_DISABLE;
  if (HAL_I2C_Init(&hi2c2) != HAL_OK)
  {
    Error_Handler();
  }
  /* USER CODE BEGIN I2C2_Init 2 */

  /* USER CODE END I2C2_Init 2 */

}

/**
  * @brief SPI1 Initialization Function
  * @param None
  * @retval None
  */
static void MX_SPI1_Init(void)
{

  /* USER CODE BEGIN SPI1_Init 0 */

  /* USER CODE END SPI1_Init 0 */

  /* USER CODE BEGIN SPI1_Init 1 */

  /* USER CODE END SPI1_Init 1 */
  /* SPI1 parameter configuration*/
  hspi1.Instance = SPI1;
  hspi1.Init.Mode = SPI_MODE_MASTER;
  hspi1.Init.Direction = SPI_DIRECTION_2LINES;
  hspi1.Init.DataSize = SPI_DATASIZE_8BIT;
  hspi1.Init.CLKPolarity = SPI_POLARITY_LOW;
  hspi1.Init.CLKPhase = SPI_PHASE_1EDGE;
  hspi1.Init.NSS = SPI_NSS_SOFT;
  hspi1.Init.BaudRatePrescaler = SPI_BAUDRATEPRESCALER_16;
  hspi1.Init.FirstBit = SPI_FIRSTBIT_MSB;
  hspi1.Init.TIMode = SPI_TIMODE_DISABLE;
  hspi1.Init.CRCCalculation = SPI_CRCCALCULATION_DISABLE;
  hspi1.Init.CRCPolynomial = 10;
  if (HAL_SPI_Init(&hspi1) != HAL_OK)
  {
    Error_Handler();
  }
  /* USER CODE BEGIN SPI1_Init 2 */

  /* USER CODE END SPI1_Init 2 */

}

/**
  * @brief TIM11 Initialization Function
  * @param None
  * @retval None
  */
static void MX_TIM11_Init(void)
{

  /* USER CODE BEGIN TIM11_Init 0 */

  /* USER CODE END TIM11_Init 0 */

  TIM_OC_InitTypeDef sConfigOC = {0};

  /* USER CODE BEGIN TIM11_Init 1 */

  /* USER CODE END TIM11_Init 1 */
  htim11.Instance = TIM11;
  htim11.Init.Prescaler = 2000-1;
  htim11.Init.CounterMode = TIM_COUNTERMODE_UP;
  htim11.Init.Period = 1000-1;
  htim11.Init.ClockDivision = TIM_CLOCKDIVISION_DIV1;
  htim11.Init.AutoReloadPreload = TIM_AUTORELOAD_PRELOAD_DISABLE;
  if (HAL_TIM_Base_Init(&htim11) != HAL_OK)
  {
    Error_Handler();
  }
  if (HAL_TIM_PWM_Init(&htim11) != HAL_OK)
  {
    Error_Handler();
  }
  sConfigOC.OCMode = TIM_OCMODE_PWM1;
  sConfigOC.Pulse = 0;
  sConfigOC.OCPolarity = TIM_OCPOLARITY_HIGH;
  sConfigOC.OCFastMode = TIM_OCFAST_DISABLE;
  if (HAL_TIM_PWM_ConfigChannel(&htim11, &sConfigOC, TIM_CHANNEL_1) != HAL_OK)
  {
    Error_Handler();
  }
  /* USER CODE BEGIN TIM11_Init 2 */

  /* USER CODE END TIM11_Init 2 */
  HAL_TIM_MspPostInit(&htim11);

}

/**
  * @brief USART1 Initialization Function
  * @param None
  * @retval None
  */
static void MX_USART1_UART_Init(void)
{

  /* USER CODE BEGIN USART1_Init 0 */

  /* USER CODE END USART1_Init 0 */

  /* USER CODE BEGIN USART1_Init 1 */

  /* USER CODE END USART1_Init 1 */
  huart1.Instance = USART1;
  huart1.Init.BaudRate = 115200;
  huart1.Init.WordLength = UART_WORDLENGTH_8B;
  huart1.Init.StopBits = UART_STOPBITS_1;
  huart1.Init.Parity = UART_PARITY_NONE;
  huart1.Init.Mode = UART_MODE_TX_RX;
  huart1.Init.HwFlowCtl = UART_HWCONTROL_NONE;
  huart1.Init.OverSampling = UART_OVERSAMPLING_16;
  if (HAL_UART_Init(&huart1) != HAL_OK)
  {
    Error_Handler();
  }
  /* USER CODE BEGIN USART1_Init 2 */

  /* USER CODE END USART1_Init 2 */

}

/**
  * @brief GPIO Initialization Function
  * @param None
  * @retval None
  */
static void MX_GPIO_Init(void)
{
  GPIO_InitTypeDef GPIO_InitStruct = {0};
/* USER CODE BEGIN MX_GPIO_Init_1 */
/* USER CODE END MX_GPIO_Init_1 */

  /* GPIO Ports Clock Enable */
  __HAL_RCC_GPIOA_CLK_ENABLE();
  __HAL_RCC_GPIOB_CLK_ENABLE();

  /*Configure GPIO pin Output Level */
  HAL_GPIO_WritePin(GPIOA, GPIO_PIN_3|GPIO_PIN_4, GPIO_PIN_RESET);

  /*Configure GPIO pin : Button_Pin */
  GPIO_InitStruct.Pin = Button_Pin;
  GPIO_InitStruct.Mode = GPIO_MODE_INPUT;
  GPIO_InitStruct.Pull = GPIO_PULLUP;
  HAL_GPIO_Init(Button_GPIO_Port, &GPIO_InitStruct);

  /*Configure GPIO pins : PA3 PA4 */
  GPIO_InitStruct.Pin = GPIO_PIN_3|GPIO_PIN_4;
  GPIO_InitStruct.Mode = GPIO_MODE_OUTPUT_PP;
  GPIO_InitStruct.Pull = GPIO_NOPULL;
  GPIO_InitStruct.Speed = GPIO_SPEED_FREQ_LOW;
  HAL_GPIO_Init(GPIOA, &GPIO_InitStruct);

/* USER CODE BEGIN MX_GPIO_Init_2 */
/* USER CODE END MX_GPIO_Init_2 */
}

/* USER CODE BEGIN 4 */

/* USER CODE END 4 */

/**
  * @brief  This function is executed in case of error occurrence.
  * @retval None
  */
void Error_Handler(void)
{
  /* USER CODE BEGIN Error_Handler_Debug */
  /* User can add his own implementation to report the HAL error return state */
  __disable_irq();
  while (1)
  {
  }
  /* USER CODE END Error_Handler_Debug */
}

#ifdef  USE_FULL_ASSERT
/**
  * @brief  Reports the name of the source file and the source line number
  *         where the assert_param error has occurred.
  * @param  file: pointer to the source file name
  * @param  line: assert_param error line source number
  * @retval None
  */
void assert_failed(uint8_t *file, uint32_t line)
{
  /* USER CODE BEGIN 6 */
  /* User can add his own implementation to report the file name and line number,
     ex: printf("Wrong parameters value: file %s on line %d\r\n", file, line) */
  /* USER CODE END 6 */
}
#endif /* USE_FULL_ASSERT */
