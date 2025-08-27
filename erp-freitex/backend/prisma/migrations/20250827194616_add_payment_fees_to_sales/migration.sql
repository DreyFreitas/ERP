-- CreateEnum
CREATE TYPE "public"."RecurrenceType" AS ENUM ('DAILY', 'WEEKLY', 'MONTHLY', 'QUARTERLY', 'SEMIANNUAL', 'ANNUAL');

-- AlterTable
ALTER TABLE "public"."financial_transactions" ADD COLUMN     "isRecurring" BOOLEAN NOT NULL DEFAULT false,
ADD COLUMN     "parentTransactionId" TEXT,
ADD COLUMN     "recurrenceEndDate" TIMESTAMP(3),
ADD COLUMN     "recurrenceInterval" INTEGER,
ADD COLUMN     "recurrenceType" "public"."RecurrenceType";

-- AlterTable
ALTER TABLE "public"."payment_methods" ADD COLUMN     "accountId" TEXT;

-- AlterTable
ALTER TABLE "public"."sales" ADD COLUMN     "discountType" TEXT,
ADD COLUMN     "finalAmount" DECIMAL(10,2),
ADD COLUMN     "totalFees" DECIMAL(10,2);

-- AddForeignKey
ALTER TABLE "public"."financial_transactions" ADD CONSTRAINT "financial_transactions_parentTransactionId_fkey" FOREIGN KEY ("parentTransactionId") REFERENCES "public"."financial_transactions"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."payment_methods" ADD CONSTRAINT "payment_methods_accountId_fkey" FOREIGN KEY ("accountId") REFERENCES "public"."financial_accounts"("id") ON DELETE SET NULL ON UPDATE CASCADE;
