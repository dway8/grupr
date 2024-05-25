-- CreateTable
CREATE TABLE "SignupRequest" (
    "id" SERIAL NOT NULL,
    "phoneNumber" TEXT NOT NULL,
    "verificationCode" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "expiresAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "SignupRequest_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "SignupRequest_phoneNumber_key" ON "SignupRequest"("phoneNumber");
