import { Module } from '@nestjs/common';
import { AkaratiService } from './akarati.service';

@Module({
  providers: [AkaratiService]
})
export class AkaratiModule {}
