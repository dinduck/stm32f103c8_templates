#include "stm32f10x.h"

int main()
{
  RCC->APB2ENR = 0x00000010;
  GPIOC->CRH = 0x00300000;
  GPIOC->ODR = 0x00000000;
  while (1)
  {
    /* code */
  }
}