-- AlterTable
ALTER TABLE "public"."payment_methods" ADD COLUMN     "isInstallmentMethod" BOOLEAN NOT NULL DEFAULT false;
