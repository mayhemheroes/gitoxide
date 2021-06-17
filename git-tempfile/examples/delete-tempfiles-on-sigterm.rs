use std::io::{stdout, Write};
use std::path::PathBuf;

fn main() -> std::io::Result<()> {
    let filepath = PathBuf::new().join("tempfile.ext");
    let _tempfile = git_tempfile::at_path(&filepath)?;
    assert!(filepath.is_file(), "a tempfile was created");

    writeln!(stdout(), "{}", filepath.display())?;
    stdout().flush()?;

    signal_hook::low_level::raise(signal_hook::consts::SIGTERM)?;
    unreachable!("the above line aborts the process, and prevents destructors from running. The tempfile will go away nonetheless");
}
