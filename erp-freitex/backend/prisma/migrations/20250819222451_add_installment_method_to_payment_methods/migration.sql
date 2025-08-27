-- AlterTable
ALTER TABLE "public"."sales" ADD COLUMN     "paymentTermId" TEXT;

-- AddForeignKey
ALTER TABLE "public"."sales" ADD CONSTRAINT "sales_paymentTermId_fkey" FOREIGN KEY ("paymentTermId") REFERENCES "public"."payment_terms"("id") ON DELETE SET NULL ON UPDATE CASCADE;
