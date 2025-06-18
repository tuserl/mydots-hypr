import subprocess
import os

FACT_FILE = os.path.expanduser("~/.cache/funfacts.txt")
BACKUP_FILE = FACT_FILE + ".bak"
MODEL = "phi3"
CONTAINER_NAME = "ollama"

def ask_docker_ollama(prompt: str) -> str:
    try:
        result = subprocess.run(
            ["docker", "exec", "-i", CONTAINER_NAME, "ollama", "run", MODEL],
            input=prompt.encode(),
            capture_output=True,
            timeout=30
        )
        return result.stdout.decode().strip()
    except Exception as e:
        return f"ERROR: {e}"

def is_incomplete(fact: str) -> bool:
    prompt = f"""You are an assistant that checks if a short sentence is complete or sounds cut-off or unfinished.
Only answer YES or NO.

Sentence: "{fact}"
Is this sentence incomplete, broken, or unfinished?

Answer:"""
    response = ask_docker_ollama(prompt)
    return response.upper().startswith("YES")

def main():
    if not os.path.exists(FACT_FILE):
        print("❌ Fact file not found.")
        return

    with open(FACT_FILE, 'r', encoding='utf-8') as f:
        lines = f.readlines()

    flagged = []

    print("🔍 Scanning for incomplete facts using Docker + Ollama...")

    for i, line in enumerate(lines):
        if '|' not in line:
            continue
        date, fact = line.strip().split('|', 1)
        if is_incomplete(fact):
            flagged.append((i + 1, line.strip()))

    if not flagged:
        print("✅ No incomplete facts found.")
        return

    print(f"\n⚠️ Found {len(flagged)} possibly incomplete fact(s):\n")

    keep_lines = []
    deleted_count = 0

    for i, line in enumerate(lines):
        line_num = i + 1
        if any(f[0] == line_num for f in flagged):
            print(f"{line_num}: {line.strip()}")
            confirm = input("Delete this line? [y/N]: ").strip().lower()
            if confirm == 'y':
                deleted_count += 1
                continue
        keep_lines.append(line)

    if deleted_count > 0:
        print(f"\n🗂️  Backing up original file to: {BACKUP_FILE}")
        os.rename(FACT_FILE, BACKUP_FILE)
        with open(FACT_FILE, 'w', encoding='utf-8') as f:
            f.writelines(keep_lines)
        print(f"✅ Removed {deleted_count} line(s).")
    else:
        print("❌ No lines deleted.")

if __name__ == "__main__":
    main()

