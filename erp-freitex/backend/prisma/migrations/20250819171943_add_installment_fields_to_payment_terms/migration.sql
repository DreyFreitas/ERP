-- AlterTable
ALTER TABLE "public"."payment_terms" ADD COLUMN     "installmentInterval" INTEGER,
ADD COLUMN     "installmentsCount" INTEGER,
ADD COLUMN     "isInstallment" BOOLEAN NOT NULL DEFAULT false;
