
export async function sleepAsync(timeout: number)
{
    return new Promise<void>((r) =>
    {
        setTimeout(() => r(), timeout)
    })
}