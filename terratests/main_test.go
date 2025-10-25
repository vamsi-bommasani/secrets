package terratests

import (
	"bytes"
	"context"
	"encoding/json"
	"fmt"
	"os/exec"
	"path/filepath"
	"testing"
	"time"
)

// run executes a command in a given directory and captures stdout/stderr.
func run(ctx context.Context, dir string, name string, args ...string) (string, string, error) {
	cmd := exec.CommandContext(ctx, name, args...)
	cmd.Dir = dir
	var outb, errb bytes.Buffer
	cmd.Stdout = &outb
	cmd.Stderr = &errb
	err := cmd.Run()
	fmt.Printf("COMMAND: %s %v\nSTDOUT:\n%s\nSTDERR:\n%s\n", name, args, outb.String(), errb.String())
	return outb.String(), errb.String(), err
}

func TestTerraformKMSAndSecretsManager(t *testing.T) {
	ctx, cancel := context.WithTimeout(context.Background(), 30*time.Minute)
	defer cancel()

	// Terraform project root (one level up from terratests/)
	repoRoot, err := filepath.Abs("..")
	if err != nil {
		t.Fatalf("failed to determine repo root: %v", err)
	}

	// Terraform init
	if out, errOut, err := run(ctx, repoRoot, "terraform", "init", "-input=false"); err != nil {
		t.Fatalf("terraform init failed: %v\nstdout: %s\nstderr: %s", err, out, errOut)
	}

	// Terraform apply using a test variables file (optional)
	if out, errOut, err := run(ctx, repoRoot, "terraform", "apply", "-auto-approve", "-var-file=terratests/test.tfvars"); err != nil {
		t.Fatalf("terraform apply failed: %v\nstdout: %s\nstderr: %s", err, out, errOut)
	}

	// Always destroy resources at the end
	defer func() {
		if out, errOut, err := run(ctx, repoRoot, "terraform", "destroy", "-auto-approve", "-var-file=terratests/test.tfvars"); err != nil {
			t.Logf("terraform destroy failed: %v\nstdout: %s\nstderr: %s", err, out, errOut)
		}
	}()

	// ---- Validate KMS Output ----
	kmsOut, errOut, err := run(ctx, repoRoot, "terraform", "output", "-json", "kms_key_id")
	if err != nil {
		t.Fatalf("terraform output failed (kms_key_id): %v\nstdout: %s\nstderr: %s", err, kmsOut, errOut)
	}

	var kmsKeyID string
	if err := json.Unmarshal([]byte(kmsOut), &kmsKeyID); err != nil {
		t.Fatalf("failed to parse kms_key_id output: %v\noutput: %s", err, kmsOut)
	}
	if kmsKeyID == "" {
		t.Fatalf("expected kms_key_id output, got empty string")
	}
	t.Logf("✅ Created KMS Key ID: %s", kmsKeyID)

	// ---- Validate Secrets Manager Output ----
	secretOut, errOut, err := run(ctx, repoRoot, "terraform", "output", "-json", "secret_arn")
	if err != nil {
		t.Fatalf("terraform output failed (secret_arn): %v\nstdout: %s\nstderr: %s", err, secretOut, errOut)
	}

	var secretARN string
	if err := json.Unmarshal([]byte(secretOut), &secretARN); err != nil {
		t.Fatalf("failed to parse secret_arn output: %v\noutput: %s", err, secretOut)
	}
	if secretARN == "" {
		t.Fatalf("expected secret_arn output, got empty string")
	}
	t.Logf("✅ Created Secret ARN: %s", secretARN)
}
