/*
  Warnings:

  - You are about to drop the `Printer` table. If the table is not empty, all the data it contains will be lost.

*/
-- DropForeignKey
ALTER TABLE "public"."Printer" DROP CONSTRAINT "Printer_companyId_fkey";

-- DropTable
DROP TABLE "public"."Printer";

-- CreateTable
CREATE TABLE "public"."printers" (
    "id" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "description" TEXT,
    "isDefault" BOOLEAN NOT NULL DEFAULT false,
    "isActive" BOOLEAN NOT NULL DEFAULT true,
    "companyId" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "printers_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "printers_companyId_name_key" ON "public"."printers"("companyId", "name");

-- AddForeignKey
ALTER TABLE "public"."printers" ADD CONSTRAINT "printers_companyId_fkey" FOREIGN KEY ("companyId") REFERENCES "public"."companies"("id") ON DELETE CASCADE ON UPDATE CASCADE;
